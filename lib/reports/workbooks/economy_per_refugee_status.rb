module Reports
  class EconomyPerRefugeeStatus < Workbooks
    attr_accessor :record

    @statuses = Refugee.statuses

    def records
      Refugee.in_arrival
    end

    # The strucure is built to make it easy to re-arrange columns
    #   and still keep headings and data cells in sync with each other
    def columns(i = 1)
      [
        {
          heading: 'Barnets status',
          query: '@statuses.first[:name]'
        },
        {
          heading: 'Budgeterad kostnad',
          query: '@statuses.first[:refugees].size'
        },
        {
          heading: 'Förväntad schablon',
          query: 'x'
        },
        {
          heading: 'Avvikelse',
          query: "=C#{i}-B#{i}"
        },
        {
          heading: 'Utbetald schablon',
          query: 'x'
        },
        {
          heading: 'Avvikelse mellan förväntad och utbetald schablon',
          query: "=E#{i}-C#{i}"
        }
      ]
    end
  end
end
