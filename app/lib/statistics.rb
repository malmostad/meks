module Statistics
  DEFAULT_DATE_RANGE = { from: Date.new(0), to: Date.today }.freeze

  def self.number_of_days(from, to)
    days = (to.to_date - from.to_date).to_i + 1
    days = 0 if days.nil? || days.negative?
    days
  end

  def self.min_date(dates)
    dates.compact.min_by(&:to_date)
  end

  def self.max_date(dates)
    dates.compact.max_by(&:to_date)
  end
end
