module RefugeeRates
  extend ActiveSupport::Concern

  module ClassMethods
    def refugees_in_arrival_0_17
      in_arrival.age_0_17
    end

    def refugees_in_arrival_18_20
      in_arrival.age_18_20
    end

    def age_0_17
      where('date_of_birth <= ? and date_of_birth > ?', Date.today, Date.today - 18.years)
    end

    def age_18_20
      where('date_of_birth <= ? and date_of_birth > ?', Date.today - 18.years, Date.today - 21.years)
    end
  end

  included do
    def expected_rate(report_range = default_range)
      'ej klart'
    end

    def default_range
      { from: Date.new(0), to: Date.today }
    end
  end
end
