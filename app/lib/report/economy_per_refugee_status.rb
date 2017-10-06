module Report
  class EconomyPerRefugeeStatus < Economy
    def create!
      @axlsx    = Axlsx::Package.new
      @workbook = @axlsx.workbook
      @style    = Style.new(@axlsx)

      add_sheet
      @axlsx.serialize File.join(Rails.root, 'reports', @filename)
    end

    def add_sheet(name = @sheet_name)
      @sheet = @workbook.add_worksheet(name: name)
      fill_sheet
    end

    def records
      RateCategory.includes(:rates).all
    end

    # Add a sub sheet and a data row for each rate category
    def data_rows
      records.each_with_index.map do |category, i|
        @sheet.add_hyperlink(location: "'#{i18n_name(category[:human_name])}'!A1", ref: "A#{i + 2}", target: :sheet)
        cols = columns(category, i).map do |cell|
          cell
        end
        add_sub_sheet(category)
        cols
      end
    end

    def add_sub_sheet(category)
      Report::EconomyPerRefugeeStatusSubSheets.new(
        sheet_name: i18n_name(category[:human_name]),
        rates: @rates,
        costs: @costs,
        payments: @payments,
        axlsx: @axlsx
      ).create!
    end

    def refugees(category)
      rates(category).uniq.map { |hash| hash[:refugee] }
    end

    def rates(category)
      @rates = Statistics::Rates.refugees_rates_for_category(category, @range)
    end

    def costs(category)
      @costs = refugees(category).map do |refugee|
        placements = refugee_placements_within_range(refugee)
        Statistics::Cost.placements_costs_and_days(placements, @range)
      end.flatten
    end

    def payments(category)
      @payments = refugees(category).map do |refugee|
        Statistics::Payment.amount_and_days(refugee.payments, @range)
      end.flatten
    end

    def columns(category = RateCategory.new, i = 0)
      row = i + 2
      [
        {
          heading: 'Barnens status',
          query: category.human_name
        },
        {
          heading: 'Budgeterad kostnad',
          query: costs(category).map { |rate| rate[:amount] * rate[:days] }.sum
        },
        {
          heading: 'Förväntad schablon',
          query: rates(category).map { |rate| rate[:amount] * rate[:days] }.sum
        },
        {
          heading: 'Avvikelse',
          query: "=C#{row}-B#{row}"
        },
        {
          heading: 'Utbetald schablon',
          query: payments(category).map { |payment| payment[:amount] * payment[:days] }.sum
        },
        {
          heading: 'Avvikelse mellan förväntad och utbetald schablon',
          query: "=E#{row}-C#{row}"
        }
      ]
    end

    def last_row(row_number)
      [
        'SUMMA:',
        "=SUM(B2:B#{row_number})",
        "=SUM(C2:C#{row_number})",
        "=SUM(D2:D#{row_number})",
        "=SUM(E2:E#{row_number})",
        "=SUM(F2:F#{row_number})"
      ]
    end
  end
end
