class Report
  class Generator
    def initialize(workbook, records, sheet_name = {})
      @workbook = workbook
      @records = records
      @sheet_name = format_sheet_name(sheet_name)

      @axlsx = Axlsx::Package.new
      @style = Style.new(@axlsx)

      @sheet = create_sheet
      fill_sheet
    end

    def create_sheet
      @axlsx.workbook.add_worksheet(name: @sheet_name)
    end

    def fill_sheet
      add_header_row
      add_data_rows
    end

    def to_xlsx(filename)
      @axlsx.serialize File.join(Rails.root, 'reports', filename)
    end

    private

    def add_header_row
      column_headings = @sheet.add_row(
        @workbook.columns.map { |col| heading_name(col[:heading]) },
        style: @style.heading
      )
      add_header_tooltips(column_headings)
    end

    def add_header_tooltips(column_headings)
      # Add tooltip to given col headings
      # Axlsx has a bug for newer version of Excel comments
      #   so we use a workaround with validation tooltips activated when
      #   the user selects a cell. No real validation is performed.
      column_headings.cells.each_with_index do |cell, i|
        tooltip = @workbook.columns[i][:tooltip]
        next unless tooltip

        cell.style = @style.heading_with_tooltip
        @sheet.add_data_validation(
          cell.r,
          type: :textLength,
          showInputMessage: true,
          promptTitle: 'Kolumnförklaring:',
          prompt: tooltip
        )
      end
    end

    def add_data_rows
      # xlsx data rows
      # records can be and active record enumerator or an array of records
      @records.find_each do |record|
        @workbook.record = record
        @sheet.add_row(
          @workbook.columns.map { |column| column[:query] },
          types: @workbook.columns.map { |column| column[:type] || :string }
        )
      end
    end

    def format_sheet_name(sheet_name)
      sheet_name[:from] && sheet_name[:to] ? "#{sheet_name[:from]}–#{sheet_name[:to]}" : 'Inget intervall'
    end

    def heading_name(name)
      I18n.t("simple_form.labels.#{name}", default: name)
    end
  end
end
