module Economy
  # 'Familje/jourhemskostnad'
  # Calculation of FamilyAndEmergencyHomeCost for an array of placements
  class FamilyAndEmergencyHomeCost < CostWithPoRate
    def initialize(placements, options = {})
      @placements = placements
      @interval = { from: options[:from], to: (options[:to] || Date.today) }
      @po_rates = options[:po_rates] || PoRate.all
    end

    def as_array
      @as_array ||= @placements.map do |placement|
        interval = date_interval(placement.moved_in_at, placement.moved_out_at, @interval)

        placement.family_and_emergency_home_costs.map do |cost|
          ::Economy::CostWithPoRate.new(
            cost, from: interval[:form], to: interval[:to], po_rates: @po_rates
          ).as_array
        end
      end.flatten.compact
    end
  end
end
