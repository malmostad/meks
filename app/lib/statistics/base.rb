module Statistics
  class Base
    DEFAULT_DATE_RANGE = { from: Date.new(0), to: Date.today }.freeze

    def self.number_of_days(from, to)
      days = (to.to_date - from.to_date).to_i + 1
      return 0 if !days.is_a?(Integer) || days.negative?
      days
    end

    def self.earliest_date(*dates)
      dates.compact.compact.map(&:to_date).min
    end

    def self.latest_date(*dates)
      dates.compact.compact.map(&:to_date).max
    end

    def self.numshort_date(date)
      I18n.l(date, format: :numshort) unless date.nil?
    end
  end
end
