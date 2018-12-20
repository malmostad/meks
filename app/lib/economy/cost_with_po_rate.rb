# Calulates costs of type FamilyAndEmergencyHomeCost and ExtraContribution¨
#   that requires PoRate for a contractor
module Economy
  class CostWithPoRate < Base
    def initialize(cost, interval = DEFAULT_INTERVAL)
      @cost = cost
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
      @as_array ||= begin
        # Only FamilyAndEmergencyHomeCost belongs to placements
        from = latest_date(@cost.period_start, @cost&.placement&.moved_in_at, @interval[:from])
        to = earliest_date(@cost.period_end, @cost&.placement&.moved_out_at, @interval[:to])

        months_with_po_rates = months_and_po_rates(@cost.contractor_birthday, from: from, to: to)

        fee = @cost.fee || 0
        expense = @cost.expense || 0

        months_with_po_rates.map do |months_and_rate|
          {
            months: months_and_rate[:months].round(2),
            costs: (fee * months_and_rate[:po_rate] + expense).to_f
          }
        end
      end.flatten.compact
    end
  end
end
