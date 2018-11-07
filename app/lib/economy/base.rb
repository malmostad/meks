module Economy
  class Base
    DEFAULT_DATE_RANGE = { from: Date.new(0), to: Date.today }.freeze

    def self.number_of_days(from, to)
      days = (to.to_date - from.to_date).to_i + 1
      return 0 if !days.is_a?(Integer) || days.negative?
      days
    end

    def self.earliest_date(*dates)
      dates.compact.map(&:to_date).min
    end

    def self.latest_date(*dates)
      dates.compact.map(&:to_date).max
    end
  end
end
