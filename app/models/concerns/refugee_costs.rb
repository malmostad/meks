module RefugeeCosts
  extend ActiveSupport::Concern

  included do
    def total_cost
      cost = 0
      placements_costs_and_days.each do |cd|
        cost += cd[:cost] * cd[:days]
      end
      cost
    end

    # Calculate the refugees placements costs based on
    #  * the report range
    #  * the placement range
    #  * each placement.home cost ranges
    # Returns an array of hashes
    def placements_costs_and_days(report_range = default_range)
      costs = placements.includes(home: :costs).map do |placement|
        moved_out_at = placement.moved_out_at || Date.today
        moved_in_at  = placement.moved_in_at

        # Count days from the latest start date and the earliest end date
        #   by comparing the placements range and the range for the report
        count_from = [moved_in_at, report_range[:from].to_date].max_by(&:to_date)
        count_to   = [moved_out_at, report_range[:to].to_date].min_by(&:to_date)

        args = [placement, from: count_from, to: count_to]
        placement.home.use_placement_cost ? placement_cost(*args) : placement_home_costs(*args)
      end
      costs.flatten # .reject(&:nil?) || []
    end

    # Used when placement.home.use_placement_cost
    def placement_cost(placement, range = default_range)
      # Count days from the latest start date and the earliest end date
      #   by comparing the count_* with the cost's dates
      starts_at = [range[:from], placement.moved_in_at].max_by(&:to_date)
      ends_at   = placement.moved_out_at ? [range[:to], placement.moved_out_at].min_by(&:to_date) : range[:to]

      days = (ends_at - starts_at).to_i + 1
      days = 0 if days.negative? || days.nil?
      cost = placement.cost.to_i

      { cost: cost, days: days, home: placement.home.name }
    end

    # Costs per home and placement
    # Used unless home.use_placement_cost
    def placement_home_costs(placement, range = default_range)
      placement.home.costs.map do |cost|
        moved_out_at = placement.moved_out_at || range[:to]
        # Count days from the latest start date and the earliest end date
        #   by comparing the count_* with the cost's dates
        starts_at = [range[:from], placement.moved_in_at, cost.start_date].max_by(&:to_date)
        ends_at = [range[:to], moved_out_at, cost.end_date].min_by(&:to_date)
        days = (ends_at - starts_at).to_i + 1
        days = 0 if days.negative? || days.nil?

        { cost: cost.amount || 0, days: days, home: placement.home.name }
      end
    end

    private

    def default_range
      { from: Date.new(0), to: Date.today }
    end
  end
end
