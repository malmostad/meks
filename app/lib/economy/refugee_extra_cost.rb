# Extra kostnader för barn
module Economy
  class RefugeeExtraCost < Base
    def initialize(refugee, report_range = DEFAULT_DATE_RANGE)
      @refugee = refugee
      @report_range = report_range
    end

    def sum
      as_array.sum
    end

    def as_formula
      as_array.join('+')
    end

    def as_array
      @refugee.refugee_extra_costs.map do |rec|
        rec if rec.date >= @report_range[:from].to_date && rec.date <= @report_range[:to].to_date
      end.compact.map(&:amount)
    end
  end
end
