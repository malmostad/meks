module Economy
  # Calculates the following cost in the given interval for a number of placements:
  #   1. The homes daily cost if the placements home is of cost type #cost_per_day?
  #   2. The placements cost if the placements home is of cost type #cost_per_placement?
  #   3. The placements family_and_emergency_costs if the placements home is of cost type #cost_for_family_and_emergency_home?
  class PlacementAndHomeCost < Base
    def initialize(placements, interval = DEFAULT_INTERVAL)
      @placements = placements
      @interval = interval
    end

    def as_array
      @as_array ||= placements_costs_and_days(@placements)
    end

    private

    def placements_costs_and_days(placements)
      placements.map do |placement|
        from = latest_date(placement.moved_in_at, @interval[:from])
        to   = earliest_date(placement.moved_out_at, @interval[:to])
        args = [placement, from: from, to: to]

        # Which type_of_cost?
        next placement_home_costs(*args)       if placement.home.cost_per_day?
        next placement_cost(*args)             if placement.home.cost_per_placement?
        # next family_and_emergency_costs(*args) if placement.home.cost_for_family_and_emergency_home?
      end.flatten.compact
    end

    # Costs per placement
    def placement_cost(placement, interval)
      days = number_of_days(interval[:from], interval[:to])
      { amount: placement.cost.to_i, days: days }
    end

    # Cost per home
    def placement_home_costs(placement, interval)
      placement.home.costs.map do |cost|
        from = latest_date(interval[:from], cost.start_date)
        to   = earliest_date(interval[:to], cost.end_date)
        days = number_of_days(from, to)
        { amount: cost.amount.to_i, days: days }
      end
    end

    # Costs for family and emergency home
    def family_and_emergency_costs(placement, interval)
      placement.family_and_emergency_home_costs.map do |cost|
        from = latest_date(interval[:from], cost.period_start)
        to   = earliest_date(interval[:to], cost.period_end)
        months = number_of_months(from: from, to: to)
        {
          months: months,
          amount: (cost.fee + cost.expense).to_f
        }
      end
    end
  end
end
