# TODO: Specs
module Statistics
  # Refugee rates (schabloner)
  # Comments in Swedish from project specs
  class Rates < Base
    # Return the number of days for each rate and the rate amount
    def self.for_all_rate_categories(refugee, range = DEFAULT_DATE_RANGE)
      @_rate_categories_and_rates ||= RateCategory.includes(:rates).all
      x = @_rate_categories_and_rates.map do |category|
        send(
          category.qualifier[:meth],
          refugee,
          category,
          range
        )
      end.flatten.compact
      x.each do |y|
        puts "#{y[:amount]} kr #{y[:days]} dagar"
      end
      x
    end

    def self.refugees_rates_for_category(category, range = DEFAULT_DATE_RANGE)
      return [] if category.qualifier.nil?

      @_refugees_and_payments ||= Refugee.includes(:payments).all
      @_refugees_and_payments.map do |refugee|
        send(
          category.qualifier[:meth],
          refugee,
          category,
          range
        )
      end.flatten.compact
    end

    # Schablonkategori Ankomstbarn
    #
    # Måste:
    #   inte ha datum medborgarskap
    #     :citizenship_at
    #   ha inskrivningsdatum idag eller tidigare
    #     :registered
    #
    # Från-datum beräknas på senaste datum av följande:
    #    minimiålder
    #      :date_of_birth
    #    inskrivningsdatum
    #      :registered
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #    maxålder + 1 år - 1 dag
    #      :date_of_birth
    #  avslutsdatum
    #      :deregistered
    #  anvisningsdatum
    #      :municipality_placement_migrationsverket_at
    #  TUT startar
    #      :temporary_permit_starts_at
    #  PUT startar
    #      :residence_permit_at
    #  medborgarskap
    #     :citizenship_at
    # Return the number of days for each rate and the rate amount
    def self.arrival_0_17(refugee, category, range)
      return [] if
          refugee.date_of_birth.nil? ||
          refugee.registered.nil?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(refugee, category, range, rate),
          refugee.registered
        )

        to = earliest_date(
          *shared_to_attr(refugee, category, range, rate),
          refugee.deregistered,
          refugee.municipality_placement_migrationsverket_at,
          refugee.temporary_permit_starts_at,
          refugee.residence_permit_at,
          refugee.citizenship_at
        )

        amount_and_days(from, to, rate, refugee)
      end
    end

    # Schablonkategori Anvisad
    #
    # Från-datum beräknas på senaste datum av följande:
    #   minimiålder
    #     :date_of_birth
    #   utskriven till Malmö
    #     :checked_out_to_our_city
    #   anvisad
    #     :municipality_placement_migrationsverket_at
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   maxålder + 1 år - 1 dag
    #     :date_of_birth
    #   avslutad
    #     :deregistered
    # Returns the number of days and rate amouts in the PUT category's rates
    def self.assigned_0_17(refugee, category, range)
      return [] if
          refugee.date_of_birth.nil?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(refugee, category, range, rate),
          refugee.checked_out_to_our_city,
          refugee.municipality_placement_migrationsverket_at
        )

        to = earliest_date(
          *shared_to_attr(refugee, category, range, rate),
          refugee.deregistered
        )

        amount_and_days(from, to, rate, refugee)
      end
    end

    # Schablonkategori TUT
    #
    # Måste:
    #   ha datum för TUT startar
    #     :temporary_permit_starts_at
    #   ha datum för TUT slutar
    #     :temporary_permit_ends_at
    #   ha TUT som är längre än 12 månader
    #     :temporary_permit_starts_at, :temporary_permit_ends_at
    #   ha Utskriven till Malmö
    #     :checked_out_to_our_city
    #
    # Från-datum beräknas på senaste datum av följande:
    #   minimiålder
    #     :date_of_birth
    #   utskriven till Malmö
    #     :checked_out_to_our_city
    #   startdatum för TUT
    #     :temporary_permit_starts_at
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   maxålder + 1 år - 1 dag
    #     :date_of_birth
    #   avslutsdatum för TUT
    #     :temporary_permit_ends_at
    #   datum för PUT
    #     :residence_permit_at
    #   avslutsdatum
    #     :deregistered
    # Return the number of days for each rate and the rate amount
    def self.temporary_permit(refugee, category, range)
      return [] if
          refugee.date_of_birth.nil? ||
          refugee.temporary_permit_starts_at.nil? ||
          refugee.temporary_permit_ends_at.nil? ||
          refugee.checked_out_to_our_city ||
          refugee.temporary_permit_ends_at - refugee.temporary_permit_starts_at < 365

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(refugee, category, range, rate),
          refugee.checked_out_to_our_city,
          refugee.temporary_permit_starts_at
        )

        to = earliest_date(
          *shared_to_attr(refugee, category, range, rate),
          refugee.temporary_permit_ends_at,
          refugee.residence_permit_at,
          refugee.deregistered
        )

        amount_and_days(from, to, rate, refugee)
      end
    end

    # Schablonkategori PUT
    #
    # Måste:
    # Ha PUT
    #   :residence_permit_at
    # Ha Utskriven till Malmö
    #   :checked_out_to_our_city
    # inte ha
    #   :citizenship_at
    #
    # Från-datum beräknas på senaste datum av följande:
    #   minimiålder
    #     :date_of_birth
    #   startdatum för PUT
    #     :residence_permit_at
    #   utskriven till Malmö
    #     :checked_out_to_our_city
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   maxålder + 1 år - 1 dag
    #   medborgarskap
    #     :citizenship_at
    #   avslutsdatum
    #     :deregistered
    # Return the number of days for each rate and the rate amount
    def self.residence_permit(refugee, category, range)
      return [] if
        refugee.date_of_birth.nil? ||
        refugee.residence_permit_at.nil? ||
        refugee.checked_out_to_our_city.nil? ||
        refugee.citizenship_at.nil?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(refugee, category, range, rate),
          refugee.residence_permit_at,
          refugee.checked_out_to_our_city
        )

        to = earliest_date(
          *shared_to_attr(refugee, category, range, rate),
          refugee.citizenship_at,
          refugee.deregistered
        )

        amount_and_days(from, to, rate, refugee)
      end
    end

    def self.shared_from_attr(refugee, category, range, rate)
      [
        date_at_min_age(refugee.date_of_birth, category.qualifier[:min_age]),
        range[:from],
        rate[:start_date]
      ]
    end

    def self.shared_to_attr(refugee, category, range, rate)
      [
        date_at_max_age(refugee.date_of_birth, category.qualifier[:max_age]),
        range[:to],
        rate[:end_date]
      ]
    end

    def self.amount_and_days(from, to, rate, refugee)
      days = number_of_days(from, to)
      return nil if days.zero?

      { amount: rate.amount, days: days, refugee: refugee }
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
