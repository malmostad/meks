module Economy
  # Handles a special case when rates should not be calulated but actual costs should instead.
  # Affects both rate and cost calulations
  #
  # If the refugee has placements with a legal_code that has the attribute #exempt_from_rate set to true, then
  # 1. The periods for those placement must not be calulate for rates.
  # 2. All the actual costs for the refugee within those periods must be included instead
  class ReplaceRatesWithActualCosts < Base
    def initialize(refugee, interval = DEFAULT_INTERVAL)
      @refugee = refugee
      @interval = interval
      @intervals_with_exempt = intervals_with_exempt
    end

    # Returns the number of days for the costs and the cost amount
    def as_array
      return [] if @intervals_with_exempt.empty?

      @intervals_with_exempt.map do |interval_with_exempt|
        ::Economy::PlacementAndHomeCost.new(@refugee.placements, interval_with_exempt).as_array +
          ::Economy::ExtraContributionCost.new(@refugee, interval_with_exempt).as_array +
          ::Economy::RefugeeExtraCost.new(@refugee, interval_with_exempt).as_array +
          ::Economy::PlacementExtraCost.new(@refugee.placements, interval_with_exempt).as_array +
          ::Economy::FamilyAndEmergencyHomeCost.new(@refugee.placements, interval_with_exempt).as_array
      end.flatten.compact
    end

    # Returns an array of days that has exempt_from_rate
    def exempt_days_array
      # Create a range of dates in the exempt_from_rate periods and convert it to an array
      @intervals_with_exempt.map do |period|
        (period[:from].to_date..period[:to].to_date).to_a
      end.flatten
    end

    private

    # Selects the refugees placements that has a legal_code with #exempt_from_rate set to true
    # Returns and array of hashes with date intervals for those periods
    def intervals_with_exempt
      placement_intervals =
        @refugee
        .placements
        .includes(:legal_code)
        .where('moved_in_at <= ?', @interval[:to])
        .where('moved_out_at is ? or moved_out_at >= ?', nil, @interval[:from])
        .where(legal_codes: { exempt_from_rate: true })
        .pluck(:moved_in_at, :moved_out_at)
        .map do |dates|
          {
            from: latest_date(dates[0], @interval[:from]),
            to: earliest_date(dates[1], @interval[:to])
          }
        end

      remove_overlaps_in_date_intervals(placement_intervals)
    end
  end
end
