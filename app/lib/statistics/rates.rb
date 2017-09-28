# TODO: refactor common props
# TODO: n+1 for cats and rates
# Queries:
# Statistics::Rates.temporary_permit_0_17(refugee)
# Statistics::Rates.temporary_permit_18_20(refugee)
# Statistics::Rates.residence_permit_0_17(refugee)
# Statistics::Rates.residence_permit_18_20(refugee)
# Statistics::Rates.assigned_0_17(refugee)
# Statistics::Rates.arrival_0_17(refugee)
module Statistics
  # Refugee rates (schabloner)
  # Comments in Swedish from project specs
  class Rates < Base
    # Return number of days for each rate and rate amount
    def self.for_all_categories(refugee, range = DEFAULT_DATE_RANGE)
      RateCategory.includes(:rates).find_each do |category|
        send(category.name.to_sym, refugee, range, category)
      end
    end

    # Return number of days for each rate and rate amount
    def self.temporary_permit_0_17(refugee, category, range = DEFAULT_DATE_RANGE)
      temporary_permit(refugee, age(0, 17), category, range)
    end


    # Return number of days for each rate and rate amount
    def self.temporary_permit_18_20(refugee, category, range = DEFAULT_DATE_RANGE)
      temporary_permit(refugee, age(18, 20), category, range)
    end

    # Return number of days for each rate and rate amount
    def self.residence_permit_0_17(refugee, category, range = DEFAULT_DATE_RANGE)
      residence_permit(refugee, age(0, 17), category, range)
    end

    # Return number of days for each rate and rate amount
    def self.residence_permit_18_20(refugee, category, range = DEFAULT_DATE_RANGE)
      residence_permit(refugee, age(18, 20), category, range)
    end

    ## Overall:
    # SKA vara född
    #   :date_of_birth
    #
    ## Time based (calculate number of days):
    # SKA:
    #   vara mellan 0 och 17 år
    #     :date_of_birth
    #   vara inskriven
    #     :registered
    #
    # SKA INTE:
    #   vara anvisad
    #   vara avslutad
    #   ha startdatum för TUT
    #   ha startdatum för PUT
    #   ha medborgarskap
    # Return number of days for each rate and rate amount
    def self.arrival_0_17(refugee, category, range = DEFAULT_DATE_RANGE)
      return [] if
          refugee.date_of_birth.nil?

      category.rates.map do |rate|
        from = latest_date(
          # Ranges
          range[:from],
          rate[:start_date],
          # Date properties
          refugee.registered,
          refugee.municipality_placement_migrationsverket_at,
          refugee.temporary_permit_starts_at,
          refugee.residence_permit_at,
          refugee.citizenship_at,
          # Age
          refugee.date_of_birth,
          date_at_min_age(refugee.date_of_birth, 0)
        )

        to = earliest_date(
          Date.today,
          range[:to],
          rate[:end_date],
          refugee.deregistered,
          refugee.checked_out_to_our_city,
          date_at_max_age(refugee.date_of_birth, 17)
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
    def self.assigned_0_17(refugee, category, range = DEFAULT_DATE_RANGE)
      return [] if
          refugee.date_of_birth.nil? ||
          refugee.municipality_id != 135

      category.rates.map do |rate|
        from = latest_date(
          range[:from],
          rate[:start_date],
          refugee.municipality_placement_migrationsverket_at,
          refugee.date_of_birth,
          date_at_min_age(refugee.date_of_birth, 0)
        )

        to = earliest_date(
          Date.today,
          range[:to],
          rate[:end_date],
          refugee.deregistered,
          refugee.checked_out_to_our_city,
          date_at_max_age(refugee.date_of_birth, 17)
        )

        days = number_of_days(from, to)
        next if days.zero?

        { amount: rate.amount, days: days }
      end.flatten.compact
    end

    ## Måste:
    #   vara född
    #     :date_of_birth
    #   ha datum för TUT startar
    #     :temporary_permit_starts_at
    #   ha datum för TUT starar
    #     :temporary_permit_starts_at
    #   ha datum för TUT slutar
    #     :temporary_permit_ends_at
    #   ha TUT som är längre än 12 månader
    #     :temporary_permit_starts_at, :temporary_permit_ends_at
    #
    ## Från-datum, beräknas på senaste datum av följande:
    #   Minimiålder + 1 år - 1 dag
    #     :date_of_birth
    #   ha startdatum för TUT
    #     :temporary_permit_starts_at
    #   var Utskriven till Malmö
    #     :checked_out_to_our_city
    #
    ## Till-datum, beräknas på tidigaste datum av följande:
    #   Maxålder + 1 år - 1 dag
    #     :date_of_birth
    #   avslutsdatum för TUT
    #     :temporary_permit_ends_at
    #   avslutsdatum
    #     :deregistered
    #   datum för PUT
    #     :residence_permit_at
    # Return number of days for each rate and rate amount
    def self.temporary_permit(refugee, age, category, range)
      return [] if
          refugee.date_of_birth.nil? ||
          refugee.temporary_permit_starts_at.nil? ||
          refugee.temporary_permit_ends_at.nil? ||
          refugee.temporary_permit_ends_at - refugee.temporary_permit_starts_at < 1.year

      category.rates.map do |rate|
        from = latest_date(
          range[:from],
          rate[:start_date],
          refugee.checked_out_to_our_city,
          refugee.temporary_permit_starts_at,
          date_at_min_age(refugee.date_of_birth, age[:min])
        )

        to = earliest_date(
          Date.today,
          range[:to],
          rate[:end_date],
          refugee.deregistered,
          refugee.temporary_permit_ends_at,
          refugee.residence_permit_at,
          date_at_max_age(refugee.date_of_birth, age[:max])
        )

        days = number_of_days(from, to)
        next if days.zero?

        { amount: rate.amount, days: days }
      end.flatten.compact
    end

    ## Måste:
    #   vara född
    #     :date_of_birth
    #
    ## Från-datum, beräknas på senaste datum av följande:
    #   minimiålder + 1 år - 1 dag
    #     :date_of_birth
    #   Startdatum för PUT
    #     :residence_permit_at
    #   Utskriven till Malmö
    #     :checked_out_to_our_city
    #
    ## Till-datum, beräknas på tidigaste datum av följande:
    #   maxålder + 1 år - 1 dag
    #   avslutsdatum
    #     :deregistered
    #   medborgarskap
    #     :citizenship_at
    # Return number of days for each rate and rate amount
    def self.residence_permit(refugee, age, category, range)
      return [] if refugee.date_of_birth.nil?

      category.rates.map do |rate|
        from = latest_date(
          range[:from],
          rate[:start_date],
          date_at_min_age(refugee.date_of_birth, age[:min]),
          refugee.residence_permit_at,
          refugee.checked_out_to_our_city
        )

        to = earliest_date(
          Date.today,
          range[:to],
          rate[:end_date],
          date_at_max_age(refugee.date_of_birth, age[:max]),
          refugee.deregistered,
          refugee.citizenship_at
        )

        days = number_of_days(from, to)
        next if days.zero?

        { amount: rate.amount, days: days }
      end.flatten.compact
    end

    def self.age(from, to)
      { from: from, to: to }
    end

    def self.date_at_min_age(date_of_birth, age)
      date_of_birth.to_date + age.years
    end

    def self.date_at_max_age(date_of_birth, age)
      date_of_birth.to_date + age.years + 1.years - 1.day
    end
  end
end
