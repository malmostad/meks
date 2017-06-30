module Reports
  class EconomyPerRefugeeStatus < Workbooks
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
      records.each_with_index do |status, i|
        sheet = Reports::EconomyPerRefugeeStatusSubSheets.new(status: status, axlsx: @axlsx)
        sheet.create
        @sheet.add_hyperlink(location: "'#{i18n_name(status[:name])}'!A1", ref: "A#{i + 2}", target: :sheet)
      end
    end

    def records
      Refugee.statuses
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
  end
end
