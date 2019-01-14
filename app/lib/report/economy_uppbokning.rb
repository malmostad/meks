module Report
  class EconomyUppbokning < Workbooks
    def initialize(options = {})
      super(options)
    end

    # Returns all refugees with placements within the interval
    def records
      Refugee.in_our_municipality.with_placements_within(@from, @to)
    end

    def columns(refugee = Refugee.new, i = 0)
      row = i + 2

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
            ::Economy::RatesForRefugee.new(refugee, @interval).as_formula,
            # Special case, see class doc
            ::Economy::ReplaceRatesWithActualCosts.new(refugee, @interval).as_formula
          ),
          style: 'currency'
        }
      ]
    end

    def last_row(row)
      [
        'SUMMA:',
        '',
        '',
        '',
        "=SUM(E2:E#{row})"
      ]
    end
  end
end
