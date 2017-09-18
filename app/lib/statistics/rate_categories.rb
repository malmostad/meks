module Statistics
  class RateCategories < Base
    def self.expected
      0
    end

    def initialize(range = DEFAULT_DATE_RANGE)
      # Refugees need to be born and not deregistered
      @refugees = Refugee.where('date_of_birth <= ?', Date.today).where.not(deregistered: nil)
      @range = range
    end

    def age_0_17
      @refugees.where('date_of_birth > ?', 18.years.ago)
    end

    def age_18_20
      @refugees.where('date_of_birth <= ? and date_of_birth > ?', 18.years.ago, 21.years.ago)
    end

    def arrival_0_17
      @refugees.where('date_of_birth > ?', 18.years.ago)
    end
  end
end
