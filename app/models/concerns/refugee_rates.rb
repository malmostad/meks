module RefugeeRates
  extend ActiveSupport::Concern

  module ClassMethods
  end

  included do
    # TODO: implement
    def expected_rate
      '=(31*1350)'
    end

    # TODO: implement
    def paid_amount
      '=(31*1350)'
    end
  end
end
