class Report::Workbooks
  class EconomyPerRefugeeStatus
    attr_accessor :record

    def self.costs_formula(costs_per_status)
      calculation = costs_and_days.map do |cad|
        "(#{cad[:days]}*#{cad[:cost]})"
      end
      "=#{calculation.join('+')}"
    end

    def initialize(range = {})
      statuses = Refugee.costs_per_status
      i = 0
      statuses.map do |status|
        i += 1
        columns(status, i)
      end
    end

    # The strucure is built to make it easy to re-arrange columns
    #   and still keep headings and data cells in sync with each other
    def columns(status, i)
      [
        {
          heading: 'Barnets status',
          query: status[:name]
        },
        {
          heading: 'Budgeterad kostnad',
          query: status[:cost]
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
