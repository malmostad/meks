# Extra utgifter för placering
module Economy
  class PlacementExtraCost < Base
    def initialize(placements, interval)
      @placements = placements
      @interval = interval
    end

    def sum
      as_array.compact.sum
    end

    def as_formula
      as_array.join('+')
    end

    def as_array
      @placements.map do |placement|
        placement.placement_extra_costs.map do |pec|
          pec if pec.date >= @interval[:from].to_date && pec.date <= @interval[:to].to_date
        end
      end.flatten.compact.map(&:amount)
    end
  end
end
