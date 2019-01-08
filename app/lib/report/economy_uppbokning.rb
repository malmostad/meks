module Report
  class EconomyUppbokning < Workbooks
    def initialize(options = {})
      super(options)
    end

    # Returns all refugees with placements within the interval
    def records
      Refugee.with_placements_within(@from, @to)
    end

    def columns(refugee = Refugee.new, i = 0)
      row = i + 2
      payment = ::Economy::Payment.new(refugee.payments, @interval)

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
          heading: 'Förväntad intäkt',
          query: self.class.sum_formula(
            ::Economy::RatesForRefugee.new(refugee, @interval).as_formula,
            # Special case, see class doc
            ::Economy::ReplaceRatesWithActualCosts.new(refugee, @interval).as_formula
          ),
          style: 'currency'
        },
        {
          heading: 'Utbetald schablon',
          query: self.class.sum_formula(payment.as_formula),
          style: 'currency'
        },
        {
          heading: 'Avvikelse mellan förväntad intäkt och utbetald schablon',
          query: "=E#{row}-D#{row}",
          style: 'currency'
        }
      ]
    end

    def last_row(row)
      [
        'SUMMA:',
        '',
        '',
        "=SUM(D2:D#{row})",
        "=SUM(E2:E#{row})",
        "=SUM(F2:F#{row})"
      ]
    end
  end
end
