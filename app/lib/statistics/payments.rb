module Statistics
  class Payments
    # Calculate the refugees payments based on
    #  * the report range
    #  * each payment range and amount
    # Returns an array of hashes
    def self.amount_and_days(payments, range = Statistics::DEFAULT_DATE_RANGE)
      payments.map do |payment|
        period_length = (payment.period_end - payment.period_start).to_i
        daily_amount = period_length.zero? ? 0 : payment.amount / period_length
        days = days(payment, range)

        { amount: daily_amount.round, days: days }
      end.flatten
    end

    # Count days from the latest start date and the earliest end date
    #   by comparing the payments range and the range for the report
    def self.days(payment, range)
      count_from = [payment.period_start, range[:from]].max_by(&:to_date)
      count_to   = [payment.period_end, range[:to]].min_by(&:to_date)

      days = (count_to.to_date - count_from.to_date).to_i
      days = 0 if days.nil? || days.negative?
      days
    end
  end
end
