module Economy
  # Calulates costs of type FamilyAndEmergencyHomeCost and ExtraContribution
  #   that requires PoRate for a contractor
  class CostWithPoRate < Base
    def initialize(cost, options = {})
      @cost = cost
      @interval = { from: (options[:from] || cost.period_start), to: (options[:to] || Date.today) }
    end

    def sum
      as_array.map do |hash|
        hash[:months] * (hash[:fee] + hash[:po_cost] + hash[:expense])
      end.compact.sum
    end

    def as_formula
      as_array.map do |hash|
        next if hash[:months].zero?

        "#{hash[:months].round(10)}*(#{hash[:fee]}+#{hash[:po_cost]}+#{hash[:expense]})"
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
      # Collect matched rates and build an array of hashes with
      #   the rates as keys and the number of months as values, e.g.:
      # [
      #   { '32.14': 12.0 },
      #   { '31.24': 2.32 }
      # ]
      po_rates_and_months = {}
      (interval[:from]..interval[:to]).each do |date|
        rate = po_rate_for_date(date)

        po_rates_and_months[rate.to_s] ||= []
        po_rates_and_months[rate.to_s] << 1.to_f / (date.end_of_month - date.beginning_of_month + 1)
      end

      # Restructure the hashes in the array to with named keys for po_rate and months, e.g.:
      # [
      #   { po_rate: 32.14, months: 12.0 },
      #   { po_rate: 31.24, months: 2.32 }
      # ]
      #
      po_rates_and_months.keys.map do |key|
        { po_rate: key.to_f, months: po_rates_and_months[key].sum }
      end
    end

    def po_rate_for_date(date)
      po_rate = PoRate.all_cached.find do |rate|
        rate.start_date <= date && rate.end_date >= date
      end

      return 0 unless po_rate
      return 0 unless @cost.contractor_birthday

      po_rate.send(contractor_age_group(date))
    end

    # The contractors age group at the beginning of the year of `date`
    def contractor_age_group(date)
      date = date.beginning_of_year

      return :rate_under_65 if @cost.contractor_birthday > date - 65.years
      return :rate_between_65_and_81 if @cost.contractor_birthday <= date - 65.years &&
                                        @cost.contractor_birthday > date - 82.years
      return :rate_from_82 if @cost.contractor_birthday <= date - 82.years
    end
  end
end
