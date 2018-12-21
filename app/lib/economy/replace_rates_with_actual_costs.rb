module Economy
  # Handles a special case when rates should not be calulated but actual costs should instead.
  # Affects both rate and cost calulations
  #
  # If the refugee has placements with a legal_code that has the attribute
  #   #exempt_from_rate set to true, then
  # 1. The periods for those placement must not be calulate for rates.
  # 2. All the actual costs for the refugee within those periods must be included instead
  class ReplaceRatesWithActualCosts < Base
    def initialize(refugee, options = {})
      @refugee = refugee
      @interval = { from: options[:from], to: (options[:to] || Date.today) }
      @po_rates = options[:po_rates] || PoRate.all
      @intervals_with_exempt = intervals_with_exempt
    end

    # See doc at #as_array
    def sum
      as_array.sum do |x|
        next x if x.is_a? BigDecimal

        next x[:days] * x[:amount] if days_hash?(x)
        next x[:months] * x[:costs] if months_hash?(x)
        next x[:months] * (x[:fee] + x[:po_cost] + x[:expense]) if po_cost_hash?(x)
      end
    end

    # See doc at #as_array
    def as_formula
      as_array.map do |x|
        next x.to_s if x.is_a? BigDecimal
        next if x.value?(0)

        next "#{x[:days]}*#{x[:amount]}" if days_hash?(x)
        next "#{x[:months]}*#{x[:costs]}" if months_hash?(x)
        next "#{x[:months]}*(#{x[:fee]}+#{x[:po_cost]}+#{x[:expense]})" if po_cost_hash?(x)
      end.compact.join('+')
    end

    # Returns an array. Note that each hash can be of one of those three forms
    # { days: Integer, amount: Float }
    # { months: Float, costs: Float }
    # Float
    def as_array
      return [] if @intervals_with_exempt.empty?

      @intervals_with_exempt.map do |interval_with_exempt|
        ::Economy::PlacementAndHomeCost.new(@refugee.placements, interval_with_exempt).as_array +
          ::Economy::ExtraContributionCost.new(
            @refugee, interval_with_exempt.merge(po_rates: @po_rates)
          ).as_array +
          ::Economy::RefugeeExtraCost.new(@refugee, interval_with_exempt).as_array +
          ::Economy::PlacementExtraCost.new(@refugee.placements, interval_with_exempt).as_array +
          ::Economy::FamilyAndEmergencyHomeCost.new(
            @refugee.placements, interval_with_exempt.merge(po_rates: @po_rates)
          ).as_array
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
      placement_intervals = @refugee.placements.map do |placement|
        next unless placement.legal_code.exempt_from_rate?

        {
          from: latest_date(placement.moved_in_at, @interval[:from]),
          to: earliest_date(placement.moved_out_at, @interval[:to])
        }
      end.compact

      remove_overlaps_in_date_intervals(placement_intervals)
    end

    def days_hash?(hash)
      test_hash [hash[:days], hash[:amount]]
    end

    def months_hash?(hash)
      test_hash [hash[:months], hash[:costs]]
    end

    def po_cost_hash?(hash)
      test_hash [hash[:months], hash[:fee], hash[:po_cost], hash[:expense]]
    end

    def test_hash(hash)
      !hash.include?(nil) && hash.sum.positive?
    end
  end
end
