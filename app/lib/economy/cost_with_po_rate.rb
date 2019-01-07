module Economy
  # Calulates costs of type FamilyAndEmergencyHomeCost and ExtraContribution
  #   that requires PoRate for a contractor
  class CostWithPoRate < Base
    def initialize(cost, options = {})
      @cost = cost
      @interval = { from: (options[:from] || cost.period_start), to: (options[:to] || Date.today) }
      @po_rates = options[:po_rates] || PoRate.all
      @cutoff_age = contractor_cutoff_age(@cost.contractor_birthday)
    end

    def sum
      as_array.sum do |hash|
        hash[:months] * (hash[:fee] + hash[:po_cost] + hash[:expense])
      end
    end

    def as_formula
      as_array.map do |hash|
        next if hash[:months].zero?

        "#{hash[:months]}*(#{hash[:fee]}+#{hash[:po_cost]}+#{hash[:expense]})"
      end.compact.join('+')
    end

    def as_array
      @as_array ||= begin
        from = latest_date(@cost.period_start, @interval[:from])
        to = earliest_date(@cost.period_end, @interval[:to])

        fee = @cost.fee || 0
        expense = @cost.expense || 0

        months_and_po_rates(from: from, to: to).map do |months_and_rate|
          {
            months: months_and_rate[:months],
            fee: fee,
            po_cost: fee * months_and_rate[:po_rate] / 100,
            expense: expense
          }
        end
      end.flatten.compact
    end

    private

    def months_and_po_rates(interval)
      # [
      #   { '32.14': 12.0 },
      #   { '31.24': 2.32 }
      # ]
      po_rates_and_months = {}
      (interval[:from]..interval[:to]).each do |date|
        rate = po_rate_for_date(date)

        po_rates_and_months[rate.to_s] ||= 0.0
        po_rates_and_months[rate.to_s] += 1.to_f / (date.end_of_month - date.beginning_of_month + 1)
      end

      # [
      #   { months: 12.0, po_rate: 32.14 },
      #   { months: 2.32, po_rate: 31.24 }
      # ]
      #
      po_rates_and_months.keys.map do |key|
        { po_rate: key.to_f, months: po_rates_and_months[key] }
      end
    end

    def po_rate_for_date(date)
      po_rate = @po_rates.find do |rate|
        rate.start_date <= date && rate.end_date >= date
      end

      return 0 unless po_rate

      if date < @cutoff_age
        po_rate.rate_under_65
      else
        po_rate.rate_from_65
      end
    end

    # Rule: Contractors should have reached 65 years at the start of the year for a rate of >65 years to apply
    # Returns the date of the first day of the year that the rule qualifies
    def contractor_cutoff_age(birthday)
      birthday.beginning_of_year + 65.years
    end
  end
end
