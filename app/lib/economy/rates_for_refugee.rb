module Economy
  # Refugee rates (förväntade intäkter)
  # Comments in Swedish from project specs
  class RatesForRefugee < Base
    RATE_CATEGORIES_AND_RATES = RateCategory.includes(:rates).all

    def initialize(refugee, interval = DEFAULT_INTERVAL)
      @refugee = refugee
      @interval = interval
    end

    # Returns the number of days for the rate and the rate amount, or nil
    def as_array
      @as_array ||= begin
        RATE_CATEGORIES_AND_RATES.map do |category|
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
    # Returns the number of days for the rate and the rate amount, or nil
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
    # Returns the number of days for the rate and the rate amount, or nil
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
    # Returns the number of days for the rate and the rate amount, or nil
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

    # General purpose:
    # If the refugee has placements with a legal_code that has the attribute #exempt_from_rate set to true, then
    # 1. The periods for those placement must not be calulate for rates.
    # 2. All the actual costs for the refugee within those periods must be included instead
    #
    # This method:
    # Selects the refugees placements that has a legal_code with #exempt_from_rate set to true
    # Returns and array of hashes with date intervals for those periods
    def periods_with_exempt_from_rate
      @refugee.placements
              .includes(:legal_code)
              .where('moved_in_at <= ?', @interval[:to])
              .where('moved_out_at is ? or moved_out_at >= ?', nil, @interval[:from])
              .where(legal_codes: { exempt_from_rate: true })
              .pluck(:moved_in_at, :moved_out_at)
              .map do |dates|
                {
                  from: latest_date(dates[0], @interval[:from]),
                  to: earliest_date(dates[1], @interval[:to])
                }
              end
    end

    private

    # Takes the arguments from and to for the qualified rate period and the rate object
    # Returns a hash with :amount and :days for the rate with exempt from rate days deducted
    def amount_and_days(from, to, rate)
      days = number_of_days_with_exempt_from_rate_deducted(from, to)
      return nil if days.zero?

      { amount: rate.amount, days: days }
    end

    # Takes the arguments from and to for a rate period
    #   and deducts days within the period that must not be calulate for rate
    #   See doc at #periods_with_exempt_from_rate above
    # Returns the number of qualified days for the rate
    def number_of_days_with_exempt_from_rate_deducted(from, to)
      return 0 unless (to.to_date - from.to_date).positive?

      # Create a range of dates in the rate period and convert it to an array
      days_with_rate = (from.to_date..to.to_date).to_a

      # Create a range of dates in the exempt_from_rate periods and convert it to an array
      days_with_exempt_from_rate = periods_with_exempt_from_rate.map do |period|
        (period[:from].to_date..period[:to].to_date).to_a
      end.flatten

      # Deduct the exempt_from_rate days array from the rate days array
      #   to get rate qualified days. Return the size of the array, i.e. the number of days
      (days_with_rate - days_with_exempt_from_rate).size
    end

    def shared_from_attr(category, rate)
      [
        date_at_min_age(@refugee.date_of_birth, category.qualifier[:min_age]),
        @interval[:from],
        rate[:start_date]
      ]
    end

    def shared_to_attr(category, rate)
      [
        date_at_max_age(@refugee.date_of_birth, category.qualifier[:max_age]),
        @interval[:to],
        rate[:end_date]
      ]
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
