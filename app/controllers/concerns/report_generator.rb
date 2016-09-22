module ReportGenerator
  extend ActiveSupport::Concern

  included do
    def generate_xlsx(template, records)
      axlsx = Axlsx::Package.new
      style = Style.new(axlsx)

      columns = YAML.load_file(
        "#{Rails.root}/app/controllers/concerns/report_generator/sheet.yml"
      )[template.to_s]

      axlsx.workbook.add_worksheet(name: "Genererad #{Date.today}") do |sheet|
        # Add column headings
        col_headings = sheet.add_row(columns.map { |col| col_heading(col['heading']) },
          style: style.heading)

        # Add tooltip to given col headings
        # Axlsx has a bug for newer version of Excel comments
        #   so we use a workaround with validation tooltips activated when
        #   the user selects a cell. No real validate is performed.
        tooltip_style_id = style.heading_with_tooltip

        col_headings.cells.each_with_index do |cell, index|
          tooltip = columns[index]['tooltip']
          next unless tooltip

          cell.style = tooltip_style_id
          sheet.add_data_validation(cell.r,
            type: :textLength,
            showInputMessage: true,
            promptTitle: 'Kolumnförklaring:',
            prompt: tooltip)
        end

        # xlsx data rows
        # records can be and active record enumerator or an array of records
        records.send(records.is_a?(Array) ? 'each' : 'find_each') do |record|
          sheet.add_row(
            columns.map do |column|
              begin
                # Note: evaled queries are not based on user input,
                # they are defined in the 'columns.yml' file
                eval column['query']
              rescue
                ''
              end
            end,
            # Styling is very performance consuming for larger sets
            # style: template.map { |_key, value| value[:style].present? ? style.send(value[:style]) : style.normal },
            types: columns.map { |column| column['type'] || :string }
          )
        end
      end
      axlsx
    end

    def send_xlsx(xlsx, base_name)
      # xlsx = xlsx.encrypt("#{base_name}.xlsx", 'meks')
      send_data xlsx.to_stream.read, type: :xlsx, disposition: 'attachment',
        # filename: "#{base_name}_#{DateTime.now.strftime('%Y-%m-%d_%H%M%S')}.xlsx"
        filename: "#{base_name}.xlsx"
    end
  end

  def col_heading(name)
    I18n.t("simple_form.labels.#{name}", default: name)
  end
end
