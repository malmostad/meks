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
          next unless placement.home.cost_for_family_and_emergency_home?

          from = latest_date(placement.moved_in_at, @interval[:from], cost.period_start)
          to   = earliest_date(placement.moved_out_at, @interval[:to], cost.period_end)
          months = number_of_months(from: from, to: to)
          next if months.zero?

          fee = cost.fee || 0
          expense = cost.expense || 0
          pu_extra = cost.pu_extra || 0

          {
            months: months,
            costs: (fee + expense + pu_extra).to_f
          }
        end
      end.flatten.compact
    end
  end
end
