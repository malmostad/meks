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
        interval = date_interval(extra_contribution)
        {
          months: months(interval),
          costs: (extra_contribution.fee + extra_contribution.expense).to_f
        }
      end
    end

    private

    def months(interval)
      (interval[:from]..interval[:to]).sum do |date|
        1.to_f / (date.end_of_month - date.beginning_of_month + 1)
      end
    end

    def date_interval(extra_contribution)
      {
        from: latest_date(extra_contribution.period_start, @interval[:from]),
        to: earliest_date(extra_contribution.period_end, @interval[:to])
      }
    end
  end
end
