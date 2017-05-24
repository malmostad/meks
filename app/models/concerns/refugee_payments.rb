module RefugeePayments
  extend ActiveSupport::Concern

  module ClassMethods
  end

  included do
    def total_payments
      payments.sum(:amount)
    end
  end
end
