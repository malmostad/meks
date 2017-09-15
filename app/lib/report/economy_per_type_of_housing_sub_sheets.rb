module Report
  class EconomyPerTypeOfHousingSubSheets < Workbooks
    def initialize(options = {})
      super(options)
      @axlsx           = options[:axlsx]
      @type_of_housing = options[:type_of_housing]
      @sheet_name      = @type_of_housing.name
    end

    def create!
      @workbook = @axlsx.workbook
      @sheet    = @workbook.add_worksheet(name: @sheet_name)
      @style    = Style.new(@axlsx)

      fill_sheet
    end

    def records
      @type_of_housing.homes
    end

    def columns(home = Home.new, i = 0)
      row = i + 2
      [
        {
          heading: 'Boende',
          query: home.name
        },
        {
          heading: 'Budgeterad kostnad',
          query: self.class.sum_formula(
            Statistics::Cost.placements_costs_and_days(home.placements, from: @from, to: @to)
          )
        },
        {
          heading: 'Förväntad schablon',
          # TODO: implement
          query: 0
        },
        {
          heading: 'Avvikelse',
          query: "=C#{row}-B#{row}"
        },
        {
          heading: 'Utbetald schablon',
          query: self.class.days_amount_formula(
            home.payments(from: @from, to: @to)
          )
        },
        {
          heading: 'Avvikelse',
          query: "=E#{row}-C#{row}"
        }
      ]
    end

    def last_row(row_number)
      [
        '',
        "=SUM(B2:B#{row_number})",
        "=SUM(C2:C#{row_number})",
        "=SUM(D2:D#{row_number})",
        "=SUM(E2:E#{row_number})",
        "=SUM(F2:F#{row_number})"
      ]
    end
  end
end
