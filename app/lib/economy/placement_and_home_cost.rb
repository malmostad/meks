module Economy
  class PlacementAndHomeCost < Base
    def initialize(placements, range = DEFAULT_DATE_RANGE)
      @placements = placements
      @range = range
    end

    def sum
      as_hash.sum { |x| x[:days] * x[:amount] }
    end

    def as_formula
      as_hash.map do |x|
        next if x.value? 0

        "#{x[:days]}*#{x[:amount]}"
      end.compact.join('+')
    end

    private

    def as_hash
      @as_hash ||= placements_costs_and_days(@placements, @range)
    end

    def placements_costs_and_days(placements, range = DEFAULT_DATE_RANGE)
      placements.map do |placement|
        from = latest_date(placement.moved_in_at, range[:from])
        to   = earliest_date(placement.moved_out_at, range[:to])
        args = [placement, from: from, to: to]

        # Which type_of_cost?
        next placement_home_costs(*args)       if placement.home.cost_per_day?
        next placement_cost(*args)             if placement.home.cost_per_placement?
        next family_and_emergency_costs(*args) if placement.home.cost_for_family_and_emergency_home?
      end.flatten
    end

    # Costs per placement
    def placement_cost(placement, range)
      days = number_of_days(range[:from], range[:to])
      { amount: placement.cost.to_i, days: days, refugee: placement.refugee }
    end

    # Cost per home
    def placement_home_costs(placement, range)
      placement.home.costs.map do |cost|
        from = latest_date(range[:from], cost.start_date)
        to   = earliest_date(range[:to], cost.end_date)
        days = number_of_days(from, to)
        { amount: cost.amount.to_i, days: days, refugee: placement.refugee }
      end
    end

    # Costs for family and emergency
    def family_and_emergency_costs(placement, range)
      { amount: 0, days: 0, refugee: placement.refugee }
      # TODO: implement
    end
  end
end
