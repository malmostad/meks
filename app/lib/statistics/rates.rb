module Statistics
  # Refugee rates (schabloner)
  class Rates < Base
    def self.residence_permit_0_17(refugee, range = DEFAULT_DATE_RANGE)
      age = { from: 0, to: 17 }
      residence_permit(refugee, age, range)
    end

    def self.residence_permit_18_20(refugee, range = DEFAULT_DATE_RANGE)
      age = { from: 18, to: 20 }
      residence_permit(refugee, age, range)
    end

    # Number of days and rate amouts in the PUT category's rates
    def self.residence_permit(refugee, age, range)
      # SKA ha datum för ”Utskriven till Malmö” i går eller tidigare
      #     checked_out_to_our_city
      # SKA ha startdatum för PUT som har inträffat
      #     residence_permit_at
      # SKA INTE ha datum för medborgarskap som har inträffat
      #     citizenship_at
      from = latest_date(
        range[:from],
        refugee.citizenship_at,
        refugee.date_of_birth,
        refugee.date_of_birth + (age[:from] + 1).years - 1.day
      )

      to = earliest_date(
        Date.today,
        range[:to],
        refugee.deregistered,
        refugee.checked_out_to_our_city,
        refugee.residence_permit_at,
        refugee.date_of_birth + (age[:to] + 1).years - 1.day
      )

      days = number_of_days(from, to)

      amount = 123
      { amount: amount, days: days }
    end
  end
end
