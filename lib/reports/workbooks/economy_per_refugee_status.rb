module Reports
  class EconomyPerRefugeeStatus < Workbooks
    def create
      @axlsx    = Axlsx::Package.new
      @workbook = @axlsx.workbook
      @style    = Style.new(@axlsx)
      @statuses = Refugee.statuses

      add_sheet
      add_sibling_sheets

      @axlsx.serialize File.join(Rails.root, 'reports', @filename)
    end

    private

    def add_sheet(name = @sheet_name)
      @sheet = @workbook.add_worksheet(name: name)
      fill_sheet
    end

    def add_sibling_sheets
      @statuses.each_with_index do |status, i|
        name = i18n_name(status[:name])
        @workbook.add_worksheet(name: name)

        # Add link in the first columns cells to the created sheet
        @sheet.add_hyperlink(location: "'#{name}'!A1", ref: "A#{i + 2}", target: :sheet)
      end
    end

    def data_rows
      @statuses.each_with_index.map do |status, i|
        columns(status, i).map do |cell|
          cell
        end
      end
    end

    def add_data_rows
      # xlsx data rows
      # records can be and active record enumerator or an array of records
      data_rows.each do |row|
        @sheet.add_row(
          row.map { |cell| cell[:query] },
          style: row.map { |cell| cell_style(cell[:style]) },
          types: row.map { |cell| cell_type(cell[:type]) }
        )
      end
    end

    def columns(status = {}, i = 0)
      row = i + 2
      [
        {
          heading: 'Barnets status',
          query: i18n_name(status[:name]),
          style: :link
        },
        {
          heading: 'Budgeterad kostnad',
          # query: 'status[:refugees]'
          query: 220_000
        },
        {
          heading: 'Förväntad schablon',
          query: 200_000
        },
        {
          heading: 'Avvikelse',
          query: "=C#{row}-B#{row}"
        },
        {
          heading: 'Utbetald schablon',
          query: 190_000
        },
        {
          heading: 'Avvikelse mellan förväntad och utbetald schablon',
          query: "=E#{row}-C#{row}"
        }
      ]
    end
  end
end
