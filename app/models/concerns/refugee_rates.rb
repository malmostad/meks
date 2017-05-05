module RefugeeRates
  extend ActiveSupport::Concern

  module ClassMethods
  end

  included do
    # TODO: implement
    def expected_rate(report_range = { from: '1900-01-01', to: Date.today })
      'todo'
    end

    # TODO: implement
    def paid_amount
      'todo'
    end
  end
end
