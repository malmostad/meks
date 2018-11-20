module Economy
  class Base
    DEFAULT_INTERVAL = { from: Date.new(0), to: Date.today }.freeze

    def sum
      as_array.sum { |x| x[:days] * x[:amount] }
    end

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
  end
end
