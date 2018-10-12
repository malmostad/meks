# TODO: Specs
module Economy
  class ExtraContribution < Base
    def self.costs(refugee, range = DEFAULT_DATE_RANGE)
      sum_per_month = refugee.extra_contributions.sum do |extra_contribution|
        extra_contribution.fee + extra_contribution.expense
      end
    end
  end
end
