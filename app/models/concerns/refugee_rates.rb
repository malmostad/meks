# Rate categories for "Schabloner"
module RefugeeRates
  extend ActiveSupport::Concern

  module ClassMethods
    def born
      where('date_of_birth <= ?', Date.today)
    end

    def age_0_17
      born.where('date_of_birth > ?', 18.years.ago)
    end

    def age_18_20
      born.where('date_of_birth <= ? and date_of_birth > ?', 18.years.ago, 21.years.ago)
    end
  end

  included do
    def expected_rate(report_range = default_date_range)
      0
    end
  end
end
