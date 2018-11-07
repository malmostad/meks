# Extra kostnader för barn
module Economy
  class RefugeeExtraCost < Base
    def initialize(refugee, report_range = DEFAULT_DATE_RANGE)
      @refugee = refugee
      @report_range = report_range
    end

    def sum
      as_hash.sum
    end

    def as_formula
      "#{as_hash.map(&:to_s).join('+')}"
    end

    def as_hash
      @refugee.refugee_extra_costs.where(date: @report_range[:from]..@report_range[:to]).map(&:amount)
    end
  end
end
