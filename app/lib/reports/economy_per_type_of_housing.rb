module Reports
  class EconomyPerTypeOfHousing < Workbooks
    def create!
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
        sheet.create!
        @sheet.add_hyperlink(location: "'#{type_of_housing.name}'!A1", ref: "A#{i + 2}", target: :sheet)
      end
    end

    def records
      TypeOfHousing.includes(homes: [:costs, placements: :refugee]).all
    end

    def columns(type_of_housing = TypeOfHousing.new, i = 0)
      row = i + 2
      [
        {
          heading: 'Boendeform',
          query: type_of_housing.name,
          style: :link
        },
        {
          heading: 'Budgeterad kostnad',
          query: self.class.rates_formula(type_of_housing.placements_cost_per_home)
        },
        {
          heading: 'Förväntad schablon',
          query: 0
        },
        {
          heading: 'Avvikelse',
          query: "=C#{row}-B#{row}"
        },
        {
          heading: 'Utbetald schablon',
          query: 0
        },
        {
          heading: 'Avvikelse mellan förväntad och utbetald schablon',
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
