# TODO: Specs
module Economy
  class Payment < Base
    def initialize(payments, range = DEFAULT_DATE_RANGE)
      @payments = payments
      @range = range
    end

    # Calculate daily amount and number of days for payments based on
    #  * the report range
    #  * each payment's range and amount
    # Returns an array of hashes
    def as_array
      @payments.map do |payment|
        days = days(payment)
        { amount: payment.per_day, days: days, refugee: payment.refugee }
      end
    end

    # Returns comments for payments within range
    def comments
      @payments.map do |payment|
        payment.comment if days(payment).positive?
      end.compact
    end

    private

    # Returns the number of days the payment spans over within the range
    def days(payment)
      from = latest_date(payment.period_start, @range[:from])
      to   = earliest_date(payment.period_end, @range[:to])
      number_of_days(from, to)
    end
  end
end
