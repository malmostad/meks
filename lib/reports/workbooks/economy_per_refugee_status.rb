module Reports
  class EconomyPerRefugeeStatus < Workbooks
    def initialize(options = {})
      super(options)
      @type_of_housings = TypeOfHousing.all
      @statuses = Refugee.statuses
    end

    def create
      @axlsx    = Axlsx::Package.new
      @workbook = @axlsx.workbook
      @style    = Style.new(@axlsx)

      add_sheet
      add_sibling_sheets

      @axlsx.serialize File.join(Rails.root, 'reports', @filename)
    end

    def add_sheet(name = @sheet_name)
      @sheet = @workbook.add_worksheet(name: name)
      fill_sheet
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

    def add_sibling_sheets
      @statuses.each_with_index do |status, i|
        name = i18n_name(status[:name])
        @workbook.add_worksheet(name: name)

        # Add link in the first columns cells to the created sheet
        @sheet.add_hyperlink(location: "'#{name}'!A1", ref: "A#{i + 2}", target: :sheet)
      end
    end

    private

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

    def refugees
      Refugee.includes(
        :dossier_numbers, :ssns,
        :municipality,
        :gender, :homes, :municipality,
        :payments,
        placements: { home: :costs },
        current_placements: [:legal_code, home: :type_of_housings]
      ).where(registered: @from..@to)
    end

    def sibling_sheet_columns(refugee = Refugee.new, i = 0)
      row = i + 2
      [
        {
          heading: 'Budgeterad kostnad',
          query: self.class.costs_formula(refugee.placements_costs_and_days(from: @from, to: @to))
        },
        {
          heading: 'Förväntad schablon',
          query: refugee.expected_rate
        },
        {
          heading: 'Avvikelse',
          query: "=D#{row}-C#{row}"
        },
        {
          heading: 'Utbetald schablon',
          query: self.class.payments_formula(refugee.amount_and_days(from: @from, to: @to))
        },
        {
          heading: 'Avvikelse',
          query: "=D#{row}-C#{row}"
        }
      ]
    end
  end
end
