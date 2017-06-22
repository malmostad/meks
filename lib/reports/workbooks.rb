module Reports
  class Workbooks
    require 'reports/workbooks/economy'
    require 'reports/workbooks/homes'
    # require 'reports/workbooks/placements'
    # require 'reports/workbooks/refugees'
    # require 'reports/workbooks/economy_per_refugee_status'

    DEFAULT_RANGE = { from: Date.new(0), to: Date.today }.freeze

    def initialize(options = {})
      @filename   = options[:filename] || 'Utan titel.xlsx'
      @from       = options[:from]     || DEFAULT_RANGE[:from]
      @to         = options[:to]       || DEFAULT_RANGE[:to]
      @sheet_name = format_sheet_name
    end

    def create
      axlsx     = Axlsx::Package.new
      @workbook = axlsx.workbook
      @sheet    = @workbook.add_worksheet(name: @sheet_name)
      @style    = Style.new(axlsx)

      fill_sheet

      axlsx.serialize File.join(Rails.root, 'reports', @filename)
    end

    protected

    def format_sheet_name
      @from && @to ? "#{@from}–#{@to}" : 'Inget intervall'
    end

    def heading_name(name)
      I18n.t("simple_form.labels.#{name}", default: name)
    end

    private

    def fill_sheet
      add_header_row
      add_data_rows
    end

    def add_header_row
      headings = @sheet.add_row(
        header_row.map { |heading| heading_name(heading[:title]) },
        style: @style.heading
      )
      add_header_tooltips(headings)
    end

    def add_header_tooltips(headings)
      # Add tooltip to given col headings
      # Axlsx has a bug for newer version of Excel comments
      #   so we use a workaround with validation tooltips activated when
      #   the user selects a cell. No real validation is performed.
      headings.cells.each_with_index do |cell, i|
        tooltip = header_row[i][:tooltip]
        next unless tooltip

        cell.style = @style.heading_with_tooltip
        @sheet.add_data_validation(
          cell.r,
          type: :textLength,
          style: @style.heading_with_tooltip,
          showInputMessage: true,
          promptTitle: 'Kolumnförklaring:',
          prompt: tooltip
        )
      end
    end

    def add_data_rows
      # xlsx data rows
      # records can be and active record enumerator or an array of records
      data_rows.each do |row|
        @sheet.add_row(
          row.map { |data| data },
          types: cell_data_types
        )
      end
    end
  end
end
