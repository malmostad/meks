module Statistics
  # Refugee rates (schabloner)
  class Rates < Base
    def self.residence_permit_0_17(refugee, range = DEFAULT_DATE_RANGE)
      age = { from: 0, to: 17 }
      category = RateCategory.where(name: :put_0_17).first
      residence_permit(refugee, age, range, category)
    end

    def self.residence_permit_18_20(refugee, range = DEFAULT_DATE_RANGE)
      age = { from: 18, to: 20 }
      category = RateCategory.where(name: :put_18_20).first
      residence_permit(refugee, age, range, category)
    end

    # Number of days and rate amouts in the PUT category's rates
    def self.residence_permit(refugee, age, range, category)
      # Conditionals for a refugee to belong to the category:
      # SKA ha datum för ”Utskriven till Malmö” i går eller tidigare
      #     checked_out_to_our_city
      # SKA ha startdatum för PUT som har inträffat
      #     residence_permit_at
      # SKA INTE ha datum för medborgarskap som har inträffat
      #     citizenship_at
      #
      # Returns an array of hashes with amount and days for each rate range
      category.rates.map do |rate|
        from = latest_date(
          range[:from],
          refugee.citizenship_at,
          refugee.date_of_birth,
          refugee.date_of_birth + (age[:from] + 1).years - 1.day,
          rate[:start_date]
        )

        to = earliest_date(
          Date.today,
          range[:to],
          refugee.deregistered,
          refugee.checked_out_to_our_city,
          refugee.residence_permit_at,
          refugee.date_of_birth + (age[:to] + 1).years - 1.day,
          rate[:end_date]
        )

        { amount: rate.amount, days: number_of_days(from, to) }
      end
    end
  end
end
