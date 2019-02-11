module Economy
  # Extra insatser för barn
  # Calculation of ExtraContributionCost for a refugee
  class ExtraContributionCost < Base
    def initialize(refugee, options = {})
      @refugee = refugee
      @interval = { from: options[:from], to: (options[:to] || Date.today) }
      @po_rates = options[:po_rates] || PoRate.all
    end

    def sum
      as_array.map do |hash|
        next hash[:months] * hash[:costs] if months_hash?(hash)
        next hash[:months] * (hash[:fee] + hash[:po_cost] + hash[:expense]) if po_cost_hash?(hash)
      end.compact.sum
    end

    def as_formula
      as_array.map do |hash|
        next "#{hash[:months]}*#{hash[:costs]}" if months_hash?(hash)
        next "#{hash[:months]}*(#{hash[:fee]}+#{hash[:po_cost]}+#{hash[:expense]})" if po_cost_hash?(hash)
      end.compact.join('+')
    end

    def as_array
      @as_array ||= @refugee.extra_contributions.map do |extra_contribution|
        interval = date_interval(extra_contribution.period_start, extra_contribution.period_end, @interval)

        if extra_contribution.extra_contribution_type.special_case?
          { months: number_of_months(interval), costs: extra_contribution.monthly_cost }
        else
          ::Economy::CostWithPoRate.new(
            extra_contribution, interval.merge(po_rates: @po_rates)
          ).as_array
        end
      end.flatten.compact
    end
  end
end
