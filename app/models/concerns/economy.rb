module Economy
  extend ActiveSupport::Concern

  module ClassMethods
    def age_0_to_17(at_date = Date.today)
      where('date_of_birth <= ? and date_of_birth > ?', at_date - 0.years.ago.to_date, at_date - 18.years.ago.to_date)
    end

    def age_18_to_20(at_date = Date.today)
      where('date_of_birth <= ? and date_of_birth > ?', at_date - 18.years.ago.to_date, at_date - 20.years.ago.to_date)
    end

    def legal_code_sol
      where(legal_code: { name: 'SoL' })
    end
  end

  included do
  end
end
