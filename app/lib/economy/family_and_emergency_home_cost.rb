# 'Familje/jourhemskostnad'
module Economy
  class FamilyAndEmergencyHomeCost < Base
    def initialize(placements, interval = DEFAULT_INTERVAL)
      @placements = placements
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
      @as_array ||= @placements.map do |placement|
        placement.family_and_emergency_home_costs.map do |cost|
          from = latest_date(placement.moved_in_at, @interval[:from], cost.period_start)
          to = earliest_date(placement.moved_out_at, @interval[:to], cost.period_end)

          months_with_po_rates = months_and_po_rates(cost.contractor_birthday, from: from, to: to)

          fee = cost.fee || 0
          expense = cost.expense || 0

          months_with_po_rates.map do |months_and_rate|
            {
              months: months_and_rate[:months].round(2),
              costs: (fee * months_and_rate[:po_rate] + expense).to_f
            }
          end
        end
      end.flatten.compact
    end
  end
end
