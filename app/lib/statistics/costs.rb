module Statistics
  class Costs < Base
    def self.sum(placements)
      costs = placements_costs_and_days(placements)
      costs.map do |c|
        c[:amount] * c[:days]
      end.sum
    end

    def self.placements_costs_and_days(placements, range = DEFAULT_DATE_RANGE)
      placements.map do |placement|
        placement.moved_out_at ||= Date.today
        from = [placement.moved_in_at, range[:from]].max_by(&:to_date)
        to   = [placement.moved_out_at, range[:to]].min_by(&:to_date)
        args = [placement, from: from, to: to]

        # Home cost or placement costs
        placement.home.use_placement_cost ? placement_cost(*args) : placement_home_costs(*args)
      end.flatten
    end

    # Cost per home
    def self.placement_cost(placement, range)
      days = number_of_days(range[:from], range[:to])
      { amount: placement.cost.to_i, days: days }
    end

    # Costs per placement
    def self.placement_home_costs(placement, range)
      placement.home.costs.map do |cost|
        from = latest_date([range[:from], cost.start_date])
        to   = earliest_date([range[:to], cost.end_date])
        days = number_of_days(from, to)
        { amount: cost.amount.to_i, days: days }
      end
    end
  end
end
