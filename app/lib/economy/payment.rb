module Economy
  class Payment < Base
    def initialize(payments, interval)
      @payments = payments
      @interval = interval
    end

    # Calculate daily amount and number of days for payments based on
    #  * the report interval
    #  * each payment's interval and amount
    # Returns an array of hashes
    def as_array
      @payments.map do |payment|
        days = days(payment)
        { amount: payment.per_day, days: days, person: payment.person }
      end
    end

    # Returns comments for payments within interval
    def comments
      @payments.map do |payment|
        payment.comment if days(payment).positive?
      end.compact
    end

    private

    # Returns the number of days the payment spans over within the interval
    def days(payment)
      from = latest_date(payment.period_start, @interval[:from])
      to   = earliest_date(payment.period_end, @interval[:to])
      number_of_days(from, to)
    end
  end
end
