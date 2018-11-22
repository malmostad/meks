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

    protected

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

    # Brute force method for merging an array of date intervals that may overlap
    # Slow for large intervals.
    # Each date interval in hte array must be of the form `{ from: Date, to: Date }`
    # Returns an array of merged and uniqe intervals in the same form
    def merge_overlapping_date_intervals(intervals)
      # Create a sorted array of all individual days in the given intervals
      days = intervals.map do |interval|
        (interval[:from]..interval[:to]).to_a
      end.flatten.sort.uniq

      # Iterate over the array and check:
      #   If `from` is nil, start a new interval
      #   If the next item in the array isn't nil (end of array) or not
      #   the day after the given day, end the interval
      from = nil
      days.each_with_index.map do |day, i|
        from ||= day
        next unless days[i + 1].nil? || days[i + 1] != day + 1.day

        extracted_interval = { from: from, to: day }

        # Create a new interval in next loop
        from = nil

        extracted_interval
      end.compact
    end
  end
end
