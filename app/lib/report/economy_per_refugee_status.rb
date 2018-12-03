module Report
  class EconomyPerRefugeeStatus < Report::Economy
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

    # Add a data row and a sub sheet for each rate category
    def data_rows
      records.each_with_index.map do |category, i|
        @sheet.add_hyperlink(
          location: "'#{i18n_name(category[:human_name])}'!A1", ref: "A#{i + 2}",
          target: :sheet
        )

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
      @rates = ::Economy::RatesForCategory.new(category, @interval).as_array
    end

    def placements_within_range
      @placements_within_range ||= begin
        Placement.includes(
          :refugee,
          home: :costs
        ).within_range(@from, @to)
      end
    end

    def costs(category)
      costs = refugees(category).map do |refugee|
        ::Economy::PlacementAndHomeCost.new(refugee.placements, @interval).as_array.map do |x|
          # The refugee is needed for the sub sheets that lists refugees
          x.merge(refugee: refugee)
        end
      end

      @costs = costs.flatten
    end

    def payments(category)
      @payments = refugees(category).map do |refugee|
        ::Economy::Payment.new(refugee.payments, @interval).as_array
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
          heading: 'Kostnad',
          query: costs(category).map { |cost| cost[:amount] * cost[:days] }.sum
        },
        {
          heading: 'Förväntad intäkt',
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
          heading: 'Avvikelse mellan förväntad intäkt och utbetald schablon',
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
