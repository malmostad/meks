module Report
  class EconomyPerRefugeeStatusSubSheets < EconomyPerRefugeeStatus
    def initialize(options = {})
      super(options)
      @axlsx      = options[:axlsx]
      @rates      = options[:rates]
      @costs      = options[:costs]
      @payments   = options[:payments]
      @sheet_name = options[:sheet_name]
    end

    def create!
      @workbook = @axlsx.workbook
      @sheet    = @workbook.add_worksheet(name: @sheet_name)
      @style    = Style.new(@axlsx)

      fill_sheet
    end

    def records
      merge_records
    end

    # Merge arrays of @rates, @costs and @payments to one hash per refugee
    def merge_records
      @rates.map do |rate|
        refugee_id = rate[:refugee].id
        record = {}
        record[:refugee] = rate[:refugee]
        record[:rate] = rate.except(:refugee)

        record[:costs] = @costs.map do |cost|
          cost.except(:refugee) if cost[:refugee].id == refugee_id
        end.flatten.compact

        record[:payments] = @payments.map do |payments|
          payments.except(:refugee) if payments[:refugee].id == refugee_id
        end.flatten.compact
        record
      end
    end

    def data_rows
      records.each_with_index.map do |refugee, i|
        columns(refugee, i).map do |cell|
          cell
        end
      end
    end

    def columns(record = {}, i = 0)
      row = i + 2
      [
        {
          heading: 'Dossiernummer',
          query: record[:refugee]&.dossier_number
        },
        {
          heading: 'Budgeterad kostnad',
          query: record[:costs]&.map { |cost| cost[:amount] * cost[:days] }&.sum
        },
        {
          heading: 'Förväntad intäkt',
          # FIXME: shouldn't there be an array of rates for the refugee?
          query: record[:rate].present? ? record[:rate][:amount] * record[:rate][:days] : ''
        },
        {
          heading: 'Avvikelse',
          query: "=C#{row}-B#{row}"
        },
        {
          heading: 'Utbetald schablon',
          query: record[:payments]&.map { |payment| payment[:amount] * payment[:days] }&.sum
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
