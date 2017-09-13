module Statistics
  class Rates < Base
    def initialize(refugee)
      @refugee = refugee
    end

    def born
      @refugee.where('date_of_birth <= ?', Date.today)
    end

    def age_0_17
      @refugee.born.where('date_of_birth > ?', 18.years.ago)
    end

    def age_18_20
      @refugee.born.where('date_of_birth <= ? and date_of_birth > ?', 18.years.ago, 21.years.ago)
    end

    def expected(report_range = DEFAULT_DATE_RANGE)
      0
    end
  end
end
