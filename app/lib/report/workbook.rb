module Report
  class Workbook
    DEFAULT_INTERVAL = { from: Date.new(0), to: Date.today }.freeze

    def self.sum_formula(*arr)
      arr.reject!(&:blank?)
      return '' if arr.blank?

      "=(#{arr.join('+')})"
    end

    def initialize(options = {})
      @filename   = options[:filename] || 'Utan titel.xlsx'
      @from       = options[:from]     || DEFAULT_INTERVAL[:from]
      @to         = options[:to]       || DEFAULT_INTERVAL[:to]
      @interval   = { from: @from, to: @to }
      @sheet_name = format_sheet_name
    end

    def create!
      axlsx = Axlsx::Package.new
      axlsx.use_shared_strings = true
      @workbook = axlsx.workbook
      @sheet = @workbook.add_worksheet(name: @sheet_name)
      @style = Style.new(axlsx)

      fill_sheet

      Delayed::Worker.logger.info axlsx.validate
      axlsx.serialize File.join(Rails.root, 'reports', @filename)
    end

    def header_row
      columns.map do |cell|
        { title: cell[:heading], tooltip: cell[:tooltip] }
      end
    end

    def data_rows
      records.each_with_index.map do |inst, i|
        columns(inst, i).map do |cell|
          cell
        end
      end
    end

    def format_sheet_name
      @from && @to ? "#{@from.to_date}–#{@to.to_date}" : 'Inget intervall'
    end

    def i18n_name(name)
      I18n.t("simple_form.labels.#{name}", default: name)
    end

    protected

    def fill_sheet
      add_header_row
      add_data_rows
    end

    def add_header_row
      headings = @sheet.add_row(
        header_row.map { |heading| i18n_name(heading[:title]) },
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

        # Creates huge comment boxes, use add_data_validation instead
        # @sheet.add_comment(
        #   ref: cell.r,
        #   author: 'Kolumnförklaring',
        #   text: tooltip,
        #   visible: false
        # )

        @sheet.add_data_validation(
          cell.r,
          type: :textLength,
          operator: :lessThan, # Needed to create valid office ML
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
          row.map { |cell| cell[:query] },
          # :style and :type creates invalid xlsx file if the record set is large
          style: row.map do |cell|
            cell[:style] = :date if cell[:style].blank? && cell[:type] == :date
            cell_style(cell[:style])
          end,
          types: row.map do |cell|
            cell[:type] = :float if cell[:type].blank? && cell[:style] == :currency
            cell_type(cell[:type])
          end
        )
      end
      add_last_row
    end

    def add_last_row
      data_rows = records.size
      return if data_rows.zero?

      row = last_row(data_rows + 1)
      @sheet.add_row(
        row.map { |cell| cell }
      )
    end

    def cell_style(style)
      style ||= :normal
      @style.send(style)
    end

    def cell_type(type)
      type || :string
    end

    def records
      raise NotImplementedError, "Implement #{__method__} method in your #{self.class.name} subclass"
    end

    def last_row(_row_number)
      []
    end

    def columns(*_args)
      raise NotImplementedError, "Implement #{__method__} method in your #{self.class.name} subclass"
    end
  end
end
