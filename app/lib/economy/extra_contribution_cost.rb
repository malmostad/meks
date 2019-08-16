module Economy
  # Insatser för personer
  # Calculation of ExtraContributionCost for a person
  # There are two types of extra contributions with different calculations and data fields
  # 1. "Normal" type that is calculated using po_rates
  # 2. Outpatient type that has a monthly_cost field
  class ExtraContributionCost < Base
    def initialize(person, options = {})
      @person = person
      @interval = { from: options[:from], to: (options[:to] || Date.today) }
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
      @as_array ||= @person.extra_contributions.map do |extra_contribution|
        interval = date_interval(extra_contribution.period_start, extra_contribution.period_end, @interval)

        if extra_contribution.extra_contribution_type.outpatient?
          outpatient_type(interval, extra_contribution)
        else
          normal_type(interval, extra_contribution)
        end
      end.flatten.compact
    end

    private

    def normal_type(interval, extra_contribution)
      ::Economy::CostWithPoRate.new(extra_contribution, interval).as_array
    end

    def outpatient_type(interval, extra_contribution)
      { months: number_of_months(interval), costs: extra_contribution.monthly_cost }
    end
  end
end
