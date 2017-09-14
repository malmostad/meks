module Statistics
  class Payments < Base
    # Calculate daily amount and number of days for payments based on
    #  * the report range
    #  * each payment's range and amount
    # Returns an array of hashes
    def self.amount_and_days(payments, range = DEFAULT_DATE_RANGE)
      payments.map do |payment|
        days = days(payment, range)
        daily_amount = days.zero? ? 0 : payment.amount / days
        { amount: daily_amount.round, days: days }
      end
    end

    # Returns the number of days the payment spans over within the range
    def self.days(payment, range)
      from = latest_date   [payment.period_start, range[:from]]
      to   = earliest_date [payment.period_end, range[:to]]
      number_of_days(from, to)
    end
  end
end
