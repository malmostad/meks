module Economy
  # Extra insatser för barn
  # Calculation of ExtraContributionCost for a refugee
  class ExtraContributionCost < CostWithPoRate
    def initialize(refugee, options = {})
      @refugee = refugee
      @interval = { from: options[:from], to: (options[:to] || Date.today) }
      @po_rates = options[:po_rates] || PoRate.all
    end

    def as_array
      @as_array ||= @refugee.extra_contributions.map do |extra_contribution|
        interval = date_interval(extra_contribution.period_start, extra_contribution.period_end, @interval)

        ::Economy::CostWithPoRate.new(
          extra_contribution, interval.merge(po_rates: @po_rates)
        ).as_array
      end.flatten.compact
    end
  end
end
