module Report
  class EconomyPerRefugeeStatusSubSheets < EconomyPerRefugeeStatus
    def initialize(options = {})
      super(options)
      @axlsx      = options[:axlsx]
      @category   = options[:category]
      @refugees   = options[:refugees]
      @sheet_name = i18n_name(@category[:human_name])
    end

    def create!
      @workbook = @axlsx.workbook
      @sheet    = @workbook.add_worksheet(name: @sheet_name)
      @style    = Style.new(@axlsx)

      fill_sheet
    end

    def records
      @refugees
    end

    def costs(refugee)
      placements = refugee_placements_within_range(refugee)
      Statistics::Cost.placements_costs_and_days(placements, @range)
    end

    def refugee_rates_for_category(refugee)
      Statistics::Rates.send(
        @category.qualifier[:meth],
        refugee,
        @category,
        @range
      )
    end

    def data_rows
      records.each_with_index.map do |inst, i|
        columns(inst, i).map do |cell|
          cell
        end
      end
    end

    def payments(refugee)
      Statistics::Payment.amount_and_days(refugee.payments, @range)
    end

    def columns(refugee = Refugee.new, i = 0)
      row = i + 2
      [
        {
          heading: 'Dossiernummer',
          query: refugee.dossier_number
        },
        {
          heading: 'Budgeterad kostnad',
          query: costs(refugee).map { |rate| rate[:amount] * rate[:days] }.sum
        },
        {
          heading: 'Förväntad schablon',
          query: refugee_rates_for_category(refugee).map { |rate| rate[:amount] * rate[:days] }.sum
        },
        {
          heading: 'Avvikelse',
          query: "=C#{row}-B#{row}"
        },
        {
          heading: 'Utbetald schablon',
          query: payments(refugee).map { |payment| payment[:amount] * payment[:days] }.sum
        },
        {
          heading: 'Avvikelse',
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
