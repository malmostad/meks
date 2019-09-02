module Economy
  class Base
    # Implement a #sum method in the subclass if the hashes in the as_array
    #   doesn't have :days and :amount
    def sum
      as_array.map { |x| x[:days] * x[:amount] }.compact.sum
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

    def day_before(date)
      date.to_date - 1.day if date
    end

    # Returns the number of months as a float
    #   calculated from the total days in each month
    def number_of_months(interval)
      (interval[:from]..interval[:to]).sum do |date|
        1.to_f / (date.end_of_month - date.beginning_of_month + 1)
      end
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
        next if interval[:from] > interval[:to]

        interval
      end.compact
    end

    def days_hash?(hash)
      test_hash([hash[:days], hash[:amount]], hash[:days])
    end

    def months_hash?(hash)
      test_hash([hash[:months], hash[:costs]], hash[:months])
    end

    def po_cost_hash?(hash)
      test_hash([hash[:months], hash[:fee], hash[:po_cost]], hash[:months])
    end

    def test_hash(hash, time)
      !hash.include?(nil) && time.positive?
    end
  end
end
