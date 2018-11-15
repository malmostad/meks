# Extra kostnader för barn
module Economy
  class RefugeeExtraCost < Base
    def initialize(refugee_extra_costs, report_range = DEFAULT_DATE_RANGE)
      @refugee_extra_costs = refugee_extra_costs
      @report_range = report_range
    end

    def sum
      as_array.sum
    end

    def as_formula
      as_array.join('+')
    end

    def as_array
      @refugee_extra_costs.map(&:amount)
    end
  end
end
