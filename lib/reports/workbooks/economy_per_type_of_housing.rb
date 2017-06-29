module Reports
  class EconomyPerTypeOfHousing < Workbooks
    def create
      @axlsx    = Axlsx::Package.new
      @workbook = @axlsx.workbook
      @style    = Style.new(@axlsx)

      add_sheet
      add_sub_sheets

      @axlsx.serialize File.join(Rails.root, 'reports', @filename)
    end

    def add_sheet(name = @sheet_name)
      @sheet = @workbook.add_worksheet(name: name)
      fill_sheet
    end

    def add_sub_sheets
      records.each_with_index do |type_of_housing, i|
        sheet = Reports::EconomyPerTypeOfHousingSubSheets.new(type_of_housing: type_of_housing, axlsx: @axlsx)
        sheet.create
        @sheet.add_hyperlink(location: "'#{type_of_housing.name}'!A1", ref: "A#{i + 2}", target: :sheet)
      end
    end

    def records
      TypeOfHousing.includes(homes: :costs).all
    end

    def columns(type = {}, i = 0)
      row = i + 2
      [
        {
          heading: 'Barnets status',
          query: type[:name],
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

    def sub_sheet_columns(refugee = Refugee.new, i = 0)
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
