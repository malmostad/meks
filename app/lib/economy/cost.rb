module Economy
  class Cost < Base
    def self.for_type_of_housing(type_of_housing, range = DEFAULT_DATE_RANGE)
      type_of_housing.homes.map do |home|
        home.placements.map do |placement|
          placement_home_costs(placement, range)
        end
      end
    end

    def self.for_placements_and_home(placements, range = DEFAULT_DATE_RANGE)
      costs = placements_costs_and_days(placements, range)
      costs.map do |c|
        c[:amount] * c[:days]
      end.sum
    end

    def self.placements_costs_and_days(placements, range = DEFAULT_DATE_RANGE)
      placements.map do |placement|
        from = latest_date(placement.moved_in_at, range[:from])
        to   = earliest_date(placement.moved_out_at, range[:to])
        args = [placement, from: from, to: to]

        # Which type_of_cost?
        if placement.home.per_day?
          placement_home_costs(*args)
        elsif placement.home.per_placement?
          placement_cost(*args)
        elsif placement.home.for_family_and_emergency_home?
          family_and_emergency_costs(*args)
        end
      end.flatten
    end

    # Costs per placement
    def self.placement_cost(placement, range)
      days = number_of_days(range[:from], range[:to])
      { amount: placement.cost.to_i, days: days, refugee: placement.refugee }
    end

    # Cost per home
    def self.placement_home_costs(placement, range)
      placement.home.costs.map do |cost|
        from = latest_date(range[:from], cost.start_date)
        to   = earliest_date(range[:to], cost.end_date)
        days = number_of_days(from, to)
        { amount: cost.amount.to_i, days: days, refugee: placement.refugee }
      end
    end

    # Costs for family and emergency
    def self.family_and_emergency_costs(placement, range)
      # TODO: implement
    end
  end
end
