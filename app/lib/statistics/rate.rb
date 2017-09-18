module Statistics
  class Rate < Base
    def self.expected(range = DEFAULT_DATE_RANGE)
      0
    end

    def initialize(range = DEFAULT_DATE_RANGE, refugees = Refugee.all)
      # Refugees needs to be born and not deregistered
      @refugees = refugees || Refugee.where('date_of_birth <= ?', Date.today).where.not(deregistered: nil)
      @range = range
    end

    def age_0_17
      @refugees.where('date_of_birth > ?', 18.years.ago)
    end

    def age_18_20
      @refugees.where('date_of_birth <= ? and date_of_birth > ?', 18.years.ago, 21.years.ago)
    end
  end
end
