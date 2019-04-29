module Economy
  # 'Familje/jourhemskostnad'
  # Calculation of FamilyAndEmergencyHomeCost for an array of placements
  class FamilyAndEmergencyHomeCost < CostWithPoRate
    def initialize(placements, options = {})
      @placements = placements
      @interval = { from: options[:from], to: (options[:to] || Date.today) }
    end

    def as_array
      @as_array ||= @placements.map do |placement|
        interval = date_interval(placement.moved_in_at, placement.moved_out_at, @interval)

        placement.family_and_emergency_home_costs.map do |cost|
          ::Economy::CostWithPoRate.new(cost, from: interval[:from], to: interval[:to]).as_array
        end
      end.flatten.compact
    end
  end
end
