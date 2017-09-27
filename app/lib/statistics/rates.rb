# Queries:
# Statistics::Rates.residence_permit_0_17(Refugee.find(2))
# Statistics::Rates.residence_permit_18_20(Refugee.find(2))
# Statistics::Rates.assigned_0_17(Refugee.find(2))

module Statistics
  # Refugee rates (schabloner)
  class Rates < Base
    def self.residence_permit_0_17(refugee, range = DEFAULT_DATE_RANGE)
      age = { from: 0, to: 17 }
      @residence_permit_0_17_category ||= RateCategory.where(name: :put_0_17).first
      residence_permit(refugee, age, range, @residence_permit_0_17_category)
    end

    def self.residence_permit_18_20(refugee, range = DEFAULT_DATE_RANGE)
      age = { from: 18, to: 20 }
      @residence_permit_18_20_category ||= RateCategory.where(name: :put_18_20).first
      residence_permit(refugee, age, range, @residence_permit_18_20_category)
    end

    ## Overall:
    # SKA ha Anvisningskommun Malmö kommun, SRF
    #   :municipality_id
    #
    ## Time based (calculate number of days):
    # SKA vara 0–17 år
    #   :date_of_birth
    # SKA INTE vara Avslutad
    #   :deregistered
    # SKA vara Anvisad
    #   :municipality_placement_migrationsverket_at
    # SKA vara Utskriven till Malmö senast dagen innan
    #   :checked_out_to_our_city
    # Returns the number of days and rate amouts in the PUT category's rates
    def self.assigned_0_17(refugee, range = DEFAULT_DATE_RANGE)
      return [] unless refugee.municipality_id == 135 || refugee.date_of_birth

      age = { from: 0, to: 17 }
      @assigned_0_17_category ||= RateCategory.includes(:rates).where(name: :assigned_0_17).first

      @assigned_0_17_category.rates.map do |rate|
        from = latest_date(
          range[:from],
          rate[:start_date],
          refugee.municipality_placement_migrationsverket_at,
          refugee.date_of_birth,
          refugee.date_of_birth + (age[:from] + 1).years - 1.day
        )

        to = earliest_date(
          Date.today,
          range[:to],
          rate[:end_date],
          refugee.deregistered,
          refugee.checked_out_to_our_city,
          refugee.date_of_birth + (age[:to] + 1).years - 1.day
        )

        days = number_of_days(from, to)
        next if days.zero?

        { amount: rate.amount, days: days }
      end.flatten.compact
    end

    # Number of days and rate amouts in the PUT category's rates
    def self.residence_permit(refugee, age, range, category)
      # SKA INTE ha datum avslutad som har inträffat
      # SKA vara under 18 år
      # SKA INTE ha datum Avslutad som har inträffat
      # SKA ha startdatum för PUT som har inträffat
      # SKA vara Utskriven till Malmö i går eller tidigare
      # SKA INTE ha datum för medborgarskap

      # Conditionals for a refugee to belong to the category:
      # SKA ha datum för ”Utskriven till Malmö” i går eller tidigare
      #     checked_out_to_our_city
      # SKA ha startdatum för PUT som har inträffat
      #     residence_permit_at
      # SKA INTE ha datum för medborgarskap som har inträffat
      #     citizenship_at
      #
      # Returns an array of hashes with amount and days for each rate range
      return [] unless refugee.date_of_birth

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

        days = number_of_days(from, to)
        next if days.zero?

        { amount: rate.amount, days: days }
      end.flatten.compact
    end
  end
end
