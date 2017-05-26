module RefugeePayments
  extend ActiveSupport::Concern

  included do
    def total_payments
      payments.sum(:amount)
    end

    # Calculate the refugees payments based on
    #  * the report range
    #  * each payment range and amount
    # Returns an array of hashes
    def amount_and_days(report_range = default_range)
      payments.map do |payment|
        daily_amount = payment.amount / (payment.period_end - payment.period_start).to_i
        days = days_for_payment(payment, report_range)

        { daily_amount: daily_amount.round, days: days }
      end
    end

    private

    # Count days from the latest start date and the earliest end date
    #   by comparing the payments range and the range for the report
    def days_for_payment(payment, range)
      count_from = [payment.period_start, range[:from]].max_by(&:to_date)
      count_to   = [payment.period_end, range[:to]].min_by(&:to_date)
      days = (count_to - count_from).to_i
      days = 0 if days.negative? || days.nil?
      days
    end

    def default_range
      { from: Date.new(0), to: Date.today }
    end
  end
end
