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
    def daily_amount_and_days(report_range = default_range)
      payments.map do |payment|
        daily_amount = payment.amount / (payment.period_end - payment.period_start).to_i

        # Count days from the latest start date and the earliest end date
        #   by comparing the payments range and the range for the report
        count_from = [payment.period_start, report_range[:from].to_date].max_by(&:to_date)
        count_to   = [payment.period_end, report_range[:to].to_date].min_by(&:to_date)
        days = (count_to - count_from).to_i

        { daily_amount: daily_amount, days: days }
      end
    end

    def payment_per_day_and_days(report_range = default_range)
    end

    def daily_amount_for_payments
    end

    private

    def default_range
      { from: Date.new(0), to: Date.today }
    end
  end
end
