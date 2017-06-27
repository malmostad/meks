module Reports
  class EconomyPerRefugeeStatus < Workbooks
    def initialize(options = {})
      super(options)
      @statuses = Refugee.statuses
    end

    def records
      @statuses.map do |status|
        send(status[:refugees])
        status[:name]
      end
    end

    def data_rows
      @statuses.each_with_index.map do |status, i|
        columns(status, i).map do |cell|
          cell[:query]
        end
      end
    end

    # def data_rows
    #   records.map do |status|
    #     status[:refugees].map do |refugee|
    #       columns.each_with_index(refugee, i).map do |cell|
    #         cell[:query]
    #       end
    #     end
    #   end
    # end

    def columns(status = nil, row = 1)
      row += 2
      [
        {
          heading: 'Barnets status',
          query: i18n_name(status)
        },
        {
          heading: 'Budgeterad kostnad',
          query: 'status[:refugees]',
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
  end
end
