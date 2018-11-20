# Extra insatser för barn
module Economy
  class ExtraContributionCost < Base
    def initialize(refugee, interval = DEFAULT_INTERVAL)
      @refugee = refugee
      @interval = interval
    end

    def sum
      as_array.sum { |mac| mac[:months] * mac[:costs] }
    end

    def as_formula
      as_array.map do |mac|
        next if mac.value? 0

        "#{mac[:months]}*#{mac[:costs]}"
      end.compact.join('+')
    end

    def as_array
      @as_array ||= @refugee.extra_contributions.map do |extra_contribution|
        interval = date_interval(extra_contribution.period_start, extra_contribution.period_end, @interval)
        {
          months: number_of_months(interval),
          costs: (extra_contribution.fee + extra_contribution.expense).to_f
        }
      end
    end
  end
end
