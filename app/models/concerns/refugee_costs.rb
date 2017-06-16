module RefugeeCosts
  extend ActiveSupport::Concern
  DEFAULT_RANGE = { from: Date.new(0), to: Date.today }.freeze

  module ClassMethods
    def costs_per_status(range = DEFAULT_RANGE)
      statuses.map do |status|
        status_cost = status[:refugees].map do |refugee|
          placement_costs = refugee.placements_costs_and_days(range)
          next unless placement_costs

          placement_costs.map do |p|
            p[:cost] * p[:days]
          end.sum
        end.sum

        { status: status[:name], cost: status_cost }
      end
    end
  end

  included do
    def total_cost
      placements_costs_and_days.map do |cd|
        cd[:cost] * cd[:days]
      end.sum
    end

    # Calculate the refugees placements costs based on
    #  * the report range
    #  * the placement range
    #  * each placement.home cost ranges
    # Returns an array of hashes
    def placements_costs_and_days(report_range = DEFAULT_RANGE)
      costs = placements.includes(home: :costs).map do |placement|
        moved_out_at = placement.moved_out_at || Date.today
        moved_in_at  = placement.moved_in_at

        # Count days from the latest start date and the earliest end date
        #   by comparing the placements range and the range for the report
        count_from = [moved_in_at, report_range[:from].to_date].max_by(&:to_date)
        count_to   = [moved_out_at, report_range[:to].to_date].min_by(&:to_date)

        args = [placement, from: count_from.to_date, to: count_to.to_date]
        placement.home.use_placement_cost ? placement_cost(*args) : placement_home_costs(*args)
      end
      costs.flatten # .reject(&:nil?) || []
    end

    # Used when placement.home.use_placement_cost
    def placement_cost(placement, range = DEFAULT_RANGE)
      # Count days from the latest start date and the earliest end date
      #   by comparing the count_* with the cost's dates
      starts_at = [range[:from], placement.moved_in_at].max_by(&:to_date)
      ends_at   = placement.moved_out_at ? [range[:to], placement.moved_out_at].min_by(&:to_date) : range[:to]

      days = (ends_at.to_date - starts_at.to_date).to_i + 1
      days = 0 if days.negative? || days.nil?
      cost = placement.cost.to_i

      { cost: cost, days: days, home: placement.home.name }
    end

    # Costs per home and placement
    # Used unless home.use_placement_cost
    def placement_home_costs(placement, range = DEFAULT_RANGE)
      placement.home.costs.map do |cost|
        moved_out_at = placement.moved_out_at || range[:to]

        # Count days from the latest start date and the earliest end date
        #   by comparing the count_* with the cost's dates
        starts_at = [range[:from], placement.moved_in_at, cost.start_date].max_by(&:to_date)
        ends_at = [range[:to], moved_out_at, cost.end_date].min_by(&:to_date)
        days = (ends_at.to_date - starts_at.to_date).to_i + 1
        days = 0 if days.negative? || days.nil?

        { cost: cost.amount || 0, days: days, home: placement.home.name }
      end
    end
  end
end
