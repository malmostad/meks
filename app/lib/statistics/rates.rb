# TODO: DB => enum const?
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
    # Return the number of days for each rate and the rate amount
    def self.for_all_categories(refugee, range = DEFAULT_DATE_RANGE)
      @rate_categories ||= RateCategory.includes(:rates).all
      @rate_categories.map do |category|
        send(
          category.base_qualifier.to_sym,
          refugee,
          category,
          range
        )
      end.flatten.compact
    end

    ## Måste:
    #    vara född
    #      :date_of_birth
    #
    ## Från-datum beräknas på senaste datum av följande:
    #    minimiålder + 1 år - 1 dag
    #      :date_of_birth
    #    Inskrivningsdatum
    #      :registered
    #
    ## Till-datum beräknas på tidigaste datum av följande:
    #    maxålder + 1 år - 1 dag
    #      :date_of_birth
    #  Avslutsdatum
    #      :deregistered
    #  TUT startar
    #      :temporary_permit_starts_at
    #  PUT startar
    #      :residence_permit_at
    #  medborgarskap
    #     :citizenship_at
    # Return the number of days for each rate and the rate amount
    def self.arrival_0_17(refugee, category, range)
      return [] if
          refugee.date_of_birth.nil?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(refugee, category, range, rate),
          refugee.registered
        )

        to = earliest_date(
          *shared_to_attr(refugee, category, range, rate),
          refugee.deregistered,
          refugee.temporary_permit_starts_at,
          refugee.residence_permit_at,
          refugee.citizenship_at
        )

        amount_and_days(from, to, rate)
      end
    end

    # Måste:
    #   vara född
    #     :date_of_birth
    #
    ## Från-datum beräknas på senaste datum av följande:
    # SKA:
    #   vara 0–17 år
    #     :date_of_birth
    #   vara utskriven till Malmö
    #     :checked_out_to_our_city
    #   vara anvisad
    #     :municipality_placement_migrationsverket_at
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   vara avslutad
    #     :deregistered
    # Returns the number of days and rate amouts in the PUT category's rates
    def self.assigned_0_17(refugee, category, range)
      return [] if
          refugee.date_of_birth.nil?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(refugee, category, range, rate),
          refugee.municipality_placement_migrationsverket_at,
          refugee.checked_out_to_our_city
        )

        to = earliest_date(
          *shared_to_attr(refugee, category, range, rate),
          refugee.deregistered
        )

        amount_and_days(from, to, rate)
      end
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
    ## Från-datum beräknas på senaste datum av följande:
    #   Minimiålder + 1 år - 1 dag
    #     :date_of_birth
    #   ha startdatum för TUT
    #     :temporary_permit_starts_at
    #   var Utskriven till Malmö
    #     :checked_out_to_our_city
    #
    ## Till-datum beräknas på tidigaste datum av följande:
    #   Maxålder + 1 år - 1 dag
    #     :date_of_birth
    #   avslutsdatum för TUT
    #     :temporary_permit_ends_at
    #   avslutsdatum
    #     :deregistered
    #   datum för PUT
    #     :residence_permit_at
    # Return the number of days for each rate and the rate amount
    def self.temporary_permit(refugee, category, range)
      return [] if
          refugee.date_of_birth.nil? ||
          refugee.temporary_permit_starts_at.nil? ||
          refugee.temporary_permit_ends_at.nil? ||
          refugee.temporary_permit_ends_at - refugee.temporary_permit_starts_at < 1.year

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(refugee, category, range, rate),
          refugee.checked_out_to_our_city,
          refugee.temporary_permit_starts_at
        )

        to = earliest_date(
          *shared_to_attr(refugee, category, range, rate),
          refugee.deregistered,
          refugee.temporary_permit_ends_at,
          refugee.residence_permit_at
        )

        amount_and_days(from, to, rate)
      end
    end

    ## Måste:
    #   vara född
    #     :date_of_birth
    #
    ## Från-datum beräknas på senaste datum av följande:
    #   minimiålder + 1 år - 1 dag
    #     :date_of_birth
    #   Startdatum för PUT
    #     :residence_permit_at
    #   Utskriven till Malmö
    #     :checked_out_to_our_city
    #
    ## Till-datum beräknas på tidigaste datum av följande:
    #   maxålder + 1 år - 1 dag
    #   avslutsdatum
    #     :deregistered
    #   medborgarskap
    #     :citizenship_at
    # Return the number of days for each rate and the rate amount
    def self.residence_permit(refugee, category, range)
      return [] if refugee.date_of_birth.nil?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(refugee, category, range, rate),
          refugee.residence_permit_at,
          refugee.checked_out_to_our_city
        )

        to = earliest_date(
          *shared_to_attr(refugee, category, range, rate),
          refugee.deregistered,
          refugee.citizenship_at
        )

        amount_and_days(from, to, rate)
      end
    end

    def self.shared_from_attr(refugee, category, range, rate)
      [
        date_at_min_age(refugee.date_of_birth, category.min_age),
        range[:from],
        rate[:start_date]
      ]
    end

    def self.shared_to_attr(refugee, category, range, rate)
      [
        date_at_max_age(refugee.date_of_birth, category.max_age),
        range[:to],
        rate[:end_date]
      ]
    end

    def self.amount_and_days(from, to, rate)
      days = number_of_days(from, to)
      return nil if days.zero?

      { amount: rate.amount, days: days }
    end

    def self.age(from, to)
      { min: from, max: to }
    end

    def self.date_at_min_age(date_of_birth, age)
      return Date.today unless date_of_birth && age
      date_of_birth.to_date + age.years
    end

    def self.date_at_max_age(date_of_birth, age)
      return Date.today unless date_of_birth && age
      date_of_birth.to_date + age.years + 1.years - 1.day
    end
  end
end
