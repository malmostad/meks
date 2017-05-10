module RefugeeCosts
  extend ActiveSupport::Concern

  module ClassMethods
    def spreadsheet_formula(costs_and_days)
      formulas = costs_and_days.map do |cd|
        "(#{cd[:days]}*#{cd[:cost]})"
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
    # Returns an array of hashes
    def home_costs(report_range = { from: '1900-01-01', to: Date.today })
      costs = placements.includes(home: :costs).map do |placement|
        moved_out_at = placement.moved_out_at || Date.today
        moved_in_at  = placement.moved_in_at

        # Count days from the latest start date and the earliest end date
        #   by comparing the placements range and the range for the report
        count_from = [moved_in_at, report_range[:from].to_date].max_by(&:to_date)
        count_to   = [moved_out_at, report_range[:to].to_date].min_by(&:to_date)

        args = [placement, from: count_from, to: count_to]
        placement.cost ? placement_cost(*args) : placement_home_costs(*args)
      end
      costs.flatten.reject(&:nil?) || []
    end

    # Used when placement cost is set
    def placement_cost(placement, range = { from: '1900-01-01', to: Date.today })
      # Count days from the latest start date and the earliest end date
      #   by comparing the count_* with the cost's dates
      starts_at = [range[:from], placement.moved_in_at].max_by(&:to_date)
      ends_at   = placement.moved_out_at ? [range[:to], placement.moved_out_at].min_by(&:to_date) : range[:to]

      days = (ends_at - starts_at).to_i
      return [] if days.zero? || days.negative?

      { cost: placement.cost, days: days, home: placement.home.name }
    end

    # Costs per home and placement
    # Used when placement cost isn't set
    def placement_home_costs(placement, range = { from: '1900-01-01', to: Date.today })
      placement.home.costs.map do |cost|
        # Count days from the latest start date and the earliest end date
        #   by comparing the count_* with the cost's dates
        starts_at = [range[:from], cost.start_date].max_by(&:to_date)
        ends_at = [range[:to], cost.end_date].min_by(&:to_date)

        days = (ends_at - starts_at).to_i
        next if days.zero? || days.negative?

        { cost: cost.amount, days: days, home: placement.home.name }
      end
    end
  end
end
