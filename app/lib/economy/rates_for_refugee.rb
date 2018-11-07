module Economy
  # Refugee rates (förväntade intäkter)
  # Comments in Swedish from project specs
  class RatesForRefugee < Base
    def initialize(refugee, range = DEFAULT_DATE_RANGE)
      @refugee = refugee
      @range = range
    end

    def sum
      as_array.sum { |x| x[:days] * x[:amount] }
    end

    def as_formula
      as_array.map do |x|
        next if x.value? 0

        "#{x[:days]}*#{x[:amount]}"
      end.compact.join('+')
    end

    # Return the number of days for each rate and the rate amount
    def as_array
      @as_array ||= begin
        @rate_categories_and_rates ||= RateCategory.includes(:rates).all
        @rate_categories_and_rates.map do |category|
          send(category.qualifier[:meth], category)
        end.flatten.compact
      end
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
    #  avslutsdatum - 1 dag
    #      :before_deregistered
    #  anvisningsdatum - 1 dag
    #      :municipality_placement_migrationsverket_at
    #  TUT startar
    #      :temporary_permit_starts_at
    #  PUT startar
    #      :residence_permit_at
    #  medborgarskap
    #     :citizenship_at
    # Return the number of days for each rate and the rate amount
    def arrival_0_17(category)
      return [] if
          @refugee.date_of_birth.nil? ||
          @refugee.registered.nil?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(category, rate),
          @refugee.registered
        )

        to = earliest_date(
          *shared_to_attr(category, rate),
          @refugee.before_deregistered,
          @refugee.before_municipality_placement_migrationsverket_at,
          @refugee.temporary_permit_starts_at,
          @refugee.residence_permit_at,
          @refugee.citizenship_at
        )

        amount_and_days(from, to, rate)
      end
    end

    # Schablonkategori Anvisad
    #
    # Måste:
    #   ha anvisningsdatum till Malmö, dvs. ha:
    #     Utskriven till Malmö
    #       :municipality_placement_migrationsverket_at
    #     Malmö kommun (alla delar)
    #       :in_our_municipality?
    #
    # Från-datum beräknas på senaste datum av följande:
    #   minimiålder
    #     :date_of_birth
    #   anvisad
    #     :municipality_placement_migrationsverket_at
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   maxålder + 1 år - 1 dag
    #     :date_of_birth
    #   utskriven till Malmö
    #     :checked_out_to_our_city
    #   avslutad - 1 dag
    #     :deregistered
    # Returns the number of days and rate amouts in the PUT category's rates
    def assigned_0_17(category)
      return [] if
          @refugee.date_of_birth.nil? ||
          @refugee.municipality_placement_migrationsverket_at.nil? ||
          !@refugee.in_our_municipality?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(category, rate),
          @refugee.municipality_placement_migrationsverket_at
        )

        to = earliest_date(
          *shared_to_attr(category, rate),
          @refugee.checked_out_to_our_city,
          @refugee.before_deregistered
        )

        amount_and_days(from, to, rate)
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
    #   utskriven till Malmö - 1 dag
    #     :before_checked_out_to_our_city
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
    #   avslutsdatum - 1
    #     :deregistered
    # Return the number of days for each rate and the rate amount
    def temporary_permit(category)
      return [] if
          @refugee.date_of_birth.nil? ||
          @refugee.temporary_permit_starts_at.nil? ||
          @refugee.temporary_permit_ends_at.nil? ||
          @refugee.checked_out_to_our_city.nil? ||
          @refugee.temporary_permit_ends_at - @refugee.temporary_permit_starts_at < 365

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(category, rate),
          @refugee.before_checked_out_to_our_city,
          @refugee.temporary_permit_starts_at
        )

        to = earliest_date(
          *shared_to_attr(category, rate),
          @refugee.temporary_permit_ends_at,
          @refugee.residence_permit_at,
          @refugee.before_deregistered
        )

        amount_and_days(from, to, rate)
      end
    end

    # Schablonkategori PUT
    #
    # Måste:
    # Ha PUT
    #   :residence_permit_at
    # Ha Utskriven till Malmö - 1 dag
    #   :before_checked_out_to_our_city
    # inte ha medborgarskap
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
    #   avslutsdatum - 1
    #     :deregistered
    # Return the number of days for each rate and the rate amount
    def residence_permit(category)
      return [] if
        @refugee.date_of_birth.nil? ||
        @refugee.residence_permit_at.nil? ||
        @refugee.checked_out_to_our_city.nil? ||
        @refugee.citizenship_at.present?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(category, rate),
          @refugee.residence_permit_at,
          @refugee.before_checked_out_to_our_city
        )

        to = earliest_date(
          *shared_to_attr(category, rate),
          @refugee.citizenship_at,
          @refugee.before_deregistered
        )

        amount_and_days(from, to, rate)
      end
    end

    private

    def shared_from_attr(category, rate)
      [
        date_at_min_age(@refugee.date_of_birth, category.qualifier[:min_age]),
        @range[:from],
        rate[:start_date]
      ]
    end

    def shared_to_attr(category, rate)
      [
        date_at_max_age(@refugee.date_of_birth, category.qualifier[:max_age]),
        @range[:to],
        rate[:end_date]
      ]
    end

    def amount_and_days(from, to, rate)
      days = number_of_days(from, to)
      return nil if days.zero?

      { amount: rate.amount, days: days }
    end

    def age(from, to)
      { min: from, max: to }
    end

    def date_at_min_age(date_of_birth, age)
      return Date.today unless date_of_birth && age

      date_of_birth.to_date + age.years
    end

    def date_at_max_age(date_of_birth, age)
      return Date.today unless date_of_birth && age

      date_of_birth.to_date + age.years + 1.years - 1.day
    end
  end
end
