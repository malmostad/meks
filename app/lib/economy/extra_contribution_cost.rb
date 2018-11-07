# Extra insatser för barn
module Economy
  class ExtraContributionCost < Base
    def initialize(refugee, report_range = DEFAULT_DATE_RANGE)
      @refugee = refugee
      @report_range = report_range
    end

    def sum
      as_hash.sum { |mac| mac[:months] * mac[:costs] }.round(2)
    end

    def as_formula
      map = as_hash.map { |mac| "#{mac[:months]}*#{mac[:costs]}" }
      "#{map.join('+')}"
    end

    def as_hash
      @refugee.extra_contributions.map do |extra_contribution|
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
        from: self.class.latest_date(extra_contribution.period_start, @report_range[:from]),
        to: self.class.earliest_date(extra_contribution.period_end, @report_range[:to])
      }
    end
  end
end
