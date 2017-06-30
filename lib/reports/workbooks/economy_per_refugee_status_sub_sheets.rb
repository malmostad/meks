module Reports
  class EconomyPerRefugeeStatusSubSheets < Workbooks
    def initialize(options = {})
      super(options)
      @axlsx      = options[:axlsx]
      @status     = options[:status]
      @sheet_name = i18n_name(@status[:name])
    end

    def create
      @workbook = @axlsx.workbook
      @sheet    = @workbook.add_worksheet(name: @sheet_name)
      @style    = Style.new(@axlsx)

      fill_sheet
    end

    def records
      Refugee.includes(:payments, placements: { home: :costs }).send(@status[:refugees])
    end

    def columns(refugee = Refugee.new, i = 0)
      row = i + 2
      [
        {
          heading: 'Dossiernumber',
          query: refugee.dossier_number
        },
        {
          heading: 'Budgeterad kostnad',
          query: self.class.costs_formula(refugee.placements_costs_and_days(from: @from, to: @to))
        },
        {
          heading: 'Förväntad schablon',
          query: refugee.expected_rate
        },
        {
          heading: 'Avvikelse',
          query: "=C#{row}-B#{row}"
        },
        {
          heading: 'Utbetald schablon',
          query: self.class.payments_formula(refugee.amount_and_days(from: @from, to: @to))
        },
        {
          heading: 'Avvikelse',
          query: "=E#{row}-C#{row}"
        }
      ]
    end
  end
end
