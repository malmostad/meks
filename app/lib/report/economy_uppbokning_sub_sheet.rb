module Report
  class EconomyUppbokningSubSheet < Workbook
    def initialize(options = {})
      super(options)
      @sheet_name = options[:sheet_name]
      @refugees   = options[:refugees]
      @workbook   = options[:workbook]
      @style      = options[:style]
    end

    def create!
      @sheet = @workbook.add_worksheet(name: @sheet_name)

      fill_sheet
    end

    def records
      @refugees
    end

    def columns(record = { rates: {}, refugee: Refugee.new }, i = 0)
      refugee = record[:refugee]
      [
        {
          heading: 'Dossiernummer',
          query: refugee.dossier_number
        },
        {
          heading: 'Personnummer',
          query: refugee.ssn
        },
        {
          heading: 'Extra personnummer',
          query: refugee.ssns.map(&:full_ssn).join(', ')
        },
        {
          heading: 'Kommun',
          query: refugee.municipality&.name
        },
        {
          heading: 'Förväntad intäkt',
          query: self.class.sum_formula(
            record[:rates]&.map { |x| "#{x[:days]}*#{x[:amount]}" }&.compact&.join('+'),
            # Special case, see class doc
            ::Economy::ReplaceRatesWithActualCosts.new(refugee, @interval).as_formula
          ),
          style: 'currency'
        },
        {
          heading: 'Antal dygn med schablonintäkt',
          query: "=#{record[:rates]&.sum { |x| x[:days] }}"
        }
      ]
    end

    def last_row(row_number)
      [
        'SUMMA:',
        '',
        '',
        '',
        "=SUM(E2:E#{row_number})"
      ]
    end
  end
end
