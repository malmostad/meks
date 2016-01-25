module ReportGenerator
  extend ActiveSupport::Concern

  included do
    def generate_xlsx(template_name, records)
      axlsx   = Axlsx::Package.new
      style = Style.new(axlsx)

      template = Template.new.send(template_name.to_sym)

      axlsx.workbook.add_worksheet do |sheet|
        # Col headings
        sheet.add_row template.keys, style: style.heading

        # data rows
        records.each do |record|
          sheet.add_row(
            template.map { |key, value|
              begin
                eval value[:query]
              rescue
                ''
              end
            },
            # Styling is very performance consuming for larger sets
            # style: template.map { |key, value| value[:style].present? ? style.send(value[:style]) : style.normal },
            types: template.map { |key, value| value[:type] || :string }
          )
        end
      end
      axlsx
    end

    def send_xlsx(xlsx, base_name)
      send_data xlsx.to_stream.read, type: :xlsx, disposition: "attachment",
        # filename: "#{base_name}_#{DateTime.now.strftime('%Y-%m-%d_%H%M%S')}.xlsx"
        filename: "#{base_name}.xlsx"
    end
  end
end
