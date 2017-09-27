# Queries:
# Statistics::Rates.temporary_permit_0_17(refugee)
# Statistics::Rates.temporary_permit_18_20(refugee)
# Statistics::Rates.residence_permit_0_17(refugee)
# Statistics::Rates.residence_permit_18_20(refugee)
# Statistics::Rates.assigned_0_17(refugee)
# Statistics::Rates.arrival_0_17(refugee)
module Statistics
  # Refugee rates (schabloner)
  class Rates < Base
    # Return the amount and days for all rates in all rate categories
    def self.for_all_categories(refugee, range = DEFAULT_DATE_RANGE)
      RateCategory.includes(:rates).find_each do |category|
        send(category.name.to_sym, refugee, range, category)
      end
    end

    def self.temporary_permit_0_17(refugee, range = DEFAULT_DATE_RANGE, category)
      age = { from: 0, to: 17 }
      temporary_permit(refugee, age, range, category)
    end

    def self.temporary_permit_18_20(refugee, range = DEFAULT_DATE_RANGE, category)
      age = { from: 18, to: 20 }
      temporary_permit(refugee, age, range, category)
    end

    def self.residence_permit_0_17(refugee, range = DEFAULT_DATE_RANGE, category)
      age = { from: 0, to: 17 }
      residence_permit(refugee, age, range, category)
    end

    def self.residence_permit_18_20(refugee, range = DEFAULT_DATE_RANGE, category)
      age = { from: 18, to: 20 }
      residence_permit(refugee, age, range, category)
    end

    # TODO: implement
    ## Overall:
    # SKA vara född
    #   :date_of_birth
    #
    ## Time based (calculate number of days):
    # SKA:
    #   vara mellan 0 och 17 år
    #   vara inskrivningen
    #
    # SKA INTE:
    #   vara anvisad
    #   vara avslutad
    #   ha startdatum för TUT
    #   ha startdatum för PUT
    #   ha medborgarskap
    def self.arrival_0_17(refugee, range = DEFAULT_DATE_RANGE, category)
      return [] if
          refugee.date_of_birth.nil?

      age = { from: 0, to: 17 }
      []
    end

    ## Overall:
    # SKA:
    #   vara född
    #     :date_of_birth
    #   ha Anvisningskommun Malmö kommun, SRF
    #     :municipality_id
    #
    ## Time based (calculate number of days):
    # SKA:
    #   vara 0–17 år
    #     :date_of_birth
    #   vara anvisad
    #     :municipality_placement_migrationsverket_at
    #   vara utskriven till Malmö
    #     :checked_out_to_our_city
    #
    # SKA INTE
    #   vara avslutad
    #     :deregistered
    # Returns the number of days and rate amouts in the PUT category's rates
    def self.assigned_0_17(refugee, range = DEFAULT_DATE_RANGE, category)
      return [] if
          refugee.date_of_birth.nil? ||
          refugee.municipality_id != 135

      age = { from: 0, to: 17 }

      category.rates.map do |rate|
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

    ## Overall:
    # SKA:
    #   vara född
    #     :date_of_birth
    #   ha datum för TUT startar
    #     :temporary_permit_starts_at
    #   ha datum för TUT slutar
    #     :temporary_permit_ends_at
    #   ha TUT som är längre än 12 månader
    #     :temporary_permit_starts_at, :temporary_permit_ends_at
    #
    ## Time based (calculate number of days):
    # SKA:
    #   vara 0–17 år
    #     :date_of_birth
    #   ha startdatum för TUT
    #     :temporary_permit_starts_at
    #   var Utskriven till Malmö
    #     :checked_out_to_our_city
    #
    # SKA INTE:
    #   ha avslutsdatum för TUT
    #     :temporary_permit_ends_at
    #   vara avslutad
    #     :deregistered
    #  ha datum för PUT
    #   :residence_permit_at
    #
    # Number of days and rate amouts in the temporary_permit (TUT) category's rates
    def self.temporary_permit(refugee, age, range, category)
      return [] if
          refugee.date_of_birth.nil? ||
          refugee.temporary_permit_starts_at.nil? ||
          refugee.temporary_permit_ends_at.nil? ||
          refugee.temporary_permit_ends_at - refugee.temporary_permit_starts_at < 1.year

      category.rates.map do |rate|
        from = latest_date(
          range[:from],
          refugee.checked_out_to_our_city,
          refugee.temporary_permit_starts_at,
          refugee.date_of_birth,
          refugee.date_of_birth + (age[:from] + 1).years - 1.day,
          rate[:start_date]
        )

        to = earliest_date(
          Date.today,
          range[:to],
          refugee.deregistered,
          refugee.temporary_permit_ends_at,
          refugee.residence_permit_at,
          refugee.date_of_birth + (age[:to] + 1).years - 1.day,
          rate[:end_date]
        )

        days = number_of_days(from, to)
        next if days.zero?

        { amount: rate.amount, days: days }
      end.flatten.compact
    end

    ## Time based (calculate number of days):
    # SKA:
    #   vara född
    #     :date_of_birth
    #   vara utskriven till Malmö
    #     :checked_out_to_our_city
    #   ha startdatum för PUT
    #     :residence_permit_at
    #
    # SKA INTE:
    #   vara avslutad
    #     :deregistered
    #   ha medborgarskap
    #     :citizenship_at
    #
    # Returns an array of hashes with amount and days for each rate range
    def self.residence_permit(refugee, age, range, category)
      return [] if refugee.date_of_birth.nil?

      category.rates.map do |rate|
        from = latest_date(
          range[:from],
          refugee.checked_out_to_our_city,
          refugee.citizenship_at,
          refugee.date_of_birth,
          refugee.date_of_birth + (age[:from] + 1).years - 1.day,
          rate[:start_date]
        )

        to = earliest_date(
          Date.today,
          range[:to],
          refugee.deregistered,
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
