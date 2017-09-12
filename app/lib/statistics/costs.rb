module Statistics
  class Costs
    def self.placements_costs_and_days(placements, range = Statistics::DEFAULT_DATE_RANGE)
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
      days = Statistics.number_of_days(range[:from], range[:to])
      { amount: placement.cost.to_i, days: days }
    end

    # Costs per placement
    def self.placement_home_costs(placement, range)
      placement.home.costs.map do |cost|
        from = Statistics.max_date([range[:from], cost.start_date])
        to   = Statistics.min_date([range[:to], cost.end_date])
        days = Statistics.number_of_days(from, to)
        { amount: cost.amount.to_i, days: days }
      end
    end
  end
end
