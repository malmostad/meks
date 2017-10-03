module Report
  class EconomyPerRefugeeStatusSubSheets < Workbooks
    def initialize(options = {})
      super(options)
      @axlsx      = options[:axlsx]
      @status     = options[:status]
      @sheet_name = i18n_name(@status[:name])
    end

    def create!
      @workbook = @axlsx.workbook
      @sheet    = @workbook.add_worksheet(name: @sheet_name)
      @style    = Style.new(@axlsx)

      fill_sheet
    end

    def records
      Statistics::Rates.send(@status)
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
          query: self.class.days_amount_formula(
            Statistics::Cost.placements_costs_and_days(refugee.placements, from: @from, to: @to)
          )
        },
        {
          heading: 'Förväntad schablon',
          query: self.class.days_amount_formula(
            Statistics::Rates.for_all_rate_categories(refugee, from: @from, to: @to)
          )
        },
        {
          heading: 'Avvikelse',
          query: "=C#{row}-B#{row}"
        },
        {
          heading: 'Utbetald schablon',
          query: self.class.days_amount_formula(
            Statistics::Payment.amount_and_days(refugee.payments, from: @from, to: @to)
          )
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
