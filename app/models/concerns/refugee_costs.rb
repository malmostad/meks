module RefugeeCosts
  extend ActiveSupport::Concern

  module ClassMethods
    def spreadsheet_formula(costs_and_days)
      formulas = costs_and_days.map do |cd|
        "(#{cd[:cost]}*#{cd[:days]})"
      end
      "=#{formulas.join('+')}"
    end
  end

  included do
    def total_cost
      cost = 0
      home_costs.each do |cd|
        cost += cd[:cost] * cd[:days]
      end
      cost
    end

    # Calculate the refugees placements costs based on
    #  * the report range
    #  * the placement range
    #  * each placement.home cost ranges
    # Returns a string for spreadsheet formula
    def home_costs(report_range = { starts: '1900-01-01', ends: '2100-01-01' })
      placements.includes(home: :costs).map do |placement|
        moved_out_at = placement.moved_out_at || Date.today
        moved_in_at  = placement.moved_in_at

        # Count days from the latest start date and the earliest end date
        #   by comparing the placements range and the range for the report
        count_from = [moved_in_at, report_range[:starts].to_date].max_by(&:to_date)
        count_to   = [moved_out_at, report_range[:ends].to_date].min_by(&:to_date)

        # One home has many non-overlapping costs
        placement_costs(placement, count_from, count_to)
      end.flatten!.reject!(&:nil?)
    end

    def placement_costs(placement, count_from, count_to)
      placement.home.costs.map do |cost|
        # Count days from the latest start date and the earliest end date
        #   by comparing the count_* with the cost's dates
        starts_at = [count_from, cost.start_date].max_by(&:to_date)
        ends_at = [count_to, cost.end_date].min_by(&:to_date)

        days = (ends_at - starts_at).to_i
        next if days.zero? || days.negative?

        { cost: cost.amount, days: days }
      end
    end
  end
end
