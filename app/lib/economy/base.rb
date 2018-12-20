module Economy
  class Base
    DEFAULT_INTERVAL = { from: Date.new(0), to: Date.today }.freeze

    # Implement a #sum method in the subclass if the hashes in the as_array
    #   doesn't have :days and :amount
    def sum
      as_array.sum { |x| x[:days] * x[:amount] }
    end

    # Implement a #as_formula method in the subclass if the hashes in the as_array
    #   doesn't have :days and :amount
    def as_formula
      as_array.map do |x|
        next if x.value? 0

        "#{x[:days]}*#{x[:amount]}"
      end.compact.join('+')
    end

    # protected

    def as_array(*_args)
      raise NotImplementedError, "Implement #{__method__} method in your #{self.class.name} subclass"
    end

    def number_of_days(from, to)
      days = (to.to_date - from.to_date).to_i + 1
      return 0 if !days.is_a?(Integer) || days.negative?

      days
    end

    def earliest_date(*dates)
      dates.compact.map(&:to_date).min
    end

    def latest_date(*dates)
      dates.compact.map(&:to_date).max
    end

    def months_and_po_rates(contractor_birthday, interval)
      cutoff_age = contractor_cutoff_age(contractor_birthday)
      # [
      #   { '32.14': 12.0 },
      #   { '31.24': 2.32 }
      # ]
      po_rates_and_months = {}
      (interval[:from]..interval[:to]).each do |date|
        rate = po_rate_for_date(date, cutoff_age)

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

    def po_rate_for_date(date, cutoff_age)
      @po_rates ||= PoRate.all

      po_rate = @po_rates.find do |rate|
        rate.start_date <= date && rate.end_date >= date
      end

      return 0 unless po_rate

      if date < cutoff_age
        po_rate.rate_under_65
      else
        po_rate.rate_from_65
      end
    end

    # Returns the number of months as a float
    #   calculated from the total days in each month
    def number_of_months(interval)
      (interval[:from]..interval[:to]).sum do |date|
        1.to_f / (date.end_of_month - date.beginning_of_month + 1)
      end
    end

    # Rule: Contractors should have reached 65 years at the start of the year for a rate of >65 years to apply
    # Returns the date of the first day of the year that the rule qualifies
    def contractor_cutoff_age(birthday)
      birthday.beginning_of_year + 65.years
    end

    # Returns the minimum section of the cost interval and the report interval
    def date_interval(period_start, period_end, report_interval)
      {
        from: latest_date(period_start, report_interval[:from]),
        to: earliest_date(period_end, report_interval[:to])
      }
    end

    # Removes overlaps in date intervals
    # Takes an array of date intervals of the form { from: Date, to: Date }
    # Returns an array of hashes in the same format
    def remove_overlaps_in_date_intervals(intervals)
      intervals.map! do |interval|
        (intervals - [interval]).each do |other_interval|
          next if other_interval.nil?

          if (other_interval[:from]..other_interval[:to]).cover? interval[:from]
            interval[:from] = other_interval[:to] + 1.day
          end
        end
        next nil if interval[:from] > interval[:to]

        interval
      end.compact
    end
  end
end
