# Extra kostnader för barn
module Economy
  class RefugeeExtraCost < Base
    def initialize(refugee, interval = DEFAULT_INTERVAL)
      @refugee = refugee
      @interval = interval
    end

    def sum
      as_array.compact.sum
    end

    def as_formula
      as_array.join('+')
    end

    def as_array
      @refugee.refugee_extra_costs.map do |rec|
        rec if rec.date >= @interval[:from].to_date && rec.date <= @interval[:to].to_date
      end.compact.map(&:amount)
    end
  end
end
