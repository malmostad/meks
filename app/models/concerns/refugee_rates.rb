module RefugeeRates
  extend ActiveSupport::Concern

  module ClassMethods
  end

  included do
    # TODO: implement
    def expected_rate(report_range = { from: '1900-01-01', to: '2100-01-01' }) # Introducing the 2100 problem!
      'todo'
    end

    # TODO: implement
    def paid_amount
      'todo'
    end
  end
end
