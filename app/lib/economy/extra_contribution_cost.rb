# Extra insatser för barn
module Economy
  class ExtraContributionCost < Base
    def initialize(refugee, report_range = DEFAULT_DATE_RANGE)
      @refugee = refugee
      @report_range = report_range
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
        range = date_range(extra_contribution)
        {
          months: months(range),
          costs: (extra_contribution.fee + extra_contribution.expense).to_f
        }
      end
    end

    private

    def months(range)
      (range[:from]..range[:to]).sum do |date|
        1.to_f / (date.end_of_month - date.beginning_of_month + 1)
      end
    end

    def date_range(extra_contribution)
      {
        from: latest_date(extra_contribution.period_start, @report_range[:from]),
        to: earliest_date(extra_contribution.period_end, @report_range[:to])
      }
    end
  end
end