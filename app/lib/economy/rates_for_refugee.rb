module Economy
  # Refugee rates (förväntade intäkter)
  # Comments in Swedish from project specs
  class RatesForRefugee < Base
    RATE_CATEGORIES_AND_RATES = RateCategory.includes(:rates).all

    attr_reader :replace_rates

    def initialize(refugee, interval = DEFAULT_INTERVAL)
      @refugee = refugee
      @interval = interval

      # Exception from the ReplaceRatesWithActualCosts exceptions
      exception_interval = interval_for_arrival_0_17(
        RATE_CATEGORIES_AND_RATES.where(qualifier: { meth: :arrival_0_17, min_age: 0, max_age: 17 }).first
      )

      # Rates must be replaced with actual costs, see doc in ReplaceRatesWithActualCosts
      @replace_rates = ReplaceRatesWithActualCosts.new(@refugee, interval.merge(exception_interval: exception_interval))
    end

    # Sum for self and ReplaceRatesWithActualCosts
    def sum
      as_array.map { |x| x[:days] * x[:amount] }.compact.sum + @replace_rates.sum
    end

    # Formula for self and ReplaceRatesWithActualCosts
    def as_formula
      arr = as_array.map do |x|
        next if x.value? 0

        "#{x[:days]}*#{x[:amount]}"
      end

      arr << @replace_rates.as_formula
      arr&.reject!(&:blank?)
      return '0' if arr.blank?

      arr.join('+')
    end

    # Returns the number of days for the rate and the rate amount
    def as_array
      @as_array ||= begin
        RATE_CATEGORIES_AND_RATES.map do |category|
          send(category.qualifier[:meth], category)
        end.flatten.compact
      end
    end

    # Utility method for debugging.
    # Returns an hash with each rate category and the amount and days qualified
    def qualifies_as
      RATE_CATEGORIES_AND_RATES.map do |category|
        [category.qualifier.values.join('_'), send(category.qualifier[:meth], category).compact]
      end.to_h
    end

    # Schablonkategori Ankomstbarn
    #
    # Måste:
    #   inte ha datum medborgarskap
    #     :citizenship_at
    #   ha inskrivningsdatum
    #     :registered
    #
    # Från-datum beräknas på senaste datum av följande:
    #    datumet när barnet uppnått minimiålder
    #      :date_of_birth
    #    inskrivningsdatum
    #      :registered
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   datumet när barnet uppnått maxålder + 1 år – 1 dag
    #      :date_of_birth
    #   avslutsdatum - 1 dag
    #      :deregistered
    #   anvisningsdatum - 1 dag
    #      :municipality_placement_migrationsverket_at
    #  TUT startar
    #      :temporary_permit_starts_at
    #  PUT startar
    #      :residence_permit_at
    #  medborgarskap erhölls - 1 dag
    #     :citizenship_at
    # Returns the number of days for the rate and the rate amount
    def arrival_0_17(category)
      return [] if @refugee.citizenship_at? || @refugee.registered.nil?

      category.rates.map do |rate|
        interval = interval_for_arrival_0_17(category, rate)

        # The arrival rate category must not have actual cost replaced
        amount_and_days(interval[:from], interval[:to], rate, skip_replace: true)
      end
    end

    def interval_for_arrival_0_17(category, rate = {})
      return {} if @refugee.citizenship_at? || @refugee.registered.nil?

      from = latest_date(
        *shared_from_attr(category, rate),
        @refugee.registered
      )

      return {} if from.nil?

      to = earliest_date(
        *shared_to_attr(category, rate),
        day_before(@refugee.deregistered),
        day_before(@refugee.municipality_placement_migrationsverket_at),
        @refugee.temporary_permit_starts_at,
        @refugee.residence_permit_at,
        day_before(@refugee.citizenship_at)
      )

      return {} if to.nil? || from >= to

      { from: from, to: to }
    end

    # Schablonkategori Anvisad
    #
    # Måste:
    #   Anvisningskommun Malmö kommun (alla delar)
    #     :in_our_municipality?
    #
    # Från-datum beräknas på senaste datum av följande:
    #   datumet när barnet uppnått minimiålder
    #     :date_of_birth
    #   anvisningdatum
    #     :municipality_placement_migrationsverket_at
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   datumet när barnet uppnått maxålder + 1 år – 1 dag
    #     :date_of_birth
    #   utskriven till Malmö
    #     :checked_out_to_our_city
    #   avslutad - 1 dag
    #     :deregistered
    #  medborgarskap erhölls - 1 dag
    #     :citizenship_at
    # Returns the number of days and rate amounts in the PUT category's rates
    def assigned_0_17(category)
      return [] if !@refugee.in_our_municipality?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(category, rate),
          @refugee.municipality_placement_migrationsverket_at
        )

        to = earliest_date(
          *shared_to_attr(category, rate),
          @refugee.checked_out_to_our_city,
          day_before(@refugee.deregistered),
          day_before(@refugee.citizenship_at)
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
    #   datumet när barnet uppnått minimiålder
    #     :date_of_birth
    #   utskriven till Malmö - 1 dag
    #     :checked_out_to_our_city
    #   startdatum för TUT
    #     :temporary_permit_starts_at
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   datumet när barnet uppnått maxålder + 1 år – 1 dag
    #     :date_of_birth
    #   avslutsdatum för TUT
    #     :temporary_permit_ends_at
    #   datum för PUT
    #     :residence_permit_at
    #   avslutsdatum - 1 dag
    #     :deregistered
    #   medborgarskap erhölls - 1 dag
    #     :citizenship_at
    # Returns the number of days for the rate and the rate amount
    def temporary_permit(category)
      return [] if
          @refugee.temporary_permit_starts_at.nil? ||
          @refugee.temporary_permit_ends_at.nil? ||
          @refugee.temporary_permit_ends_at - @refugee.temporary_permit_starts_at < 365 ||
          @refugee.checked_out_to_our_city.nil?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(category, rate),
          day_before(@refugee.checked_out_to_our_city),
          @refugee.temporary_permit_starts_at
        )

        to = earliest_date(
          *shared_to_attr(category, rate),
          @refugee.temporary_permit_ends_at,
          @refugee.residence_permit_at,
          day_before(@refugee.deregistered),
          day_before(@refugee.citizenship_at)
        )

        amount_and_days(from, to, rate)
      end
    end

    # Schablonkategori PUT
    #
    # Måste:
    # Ha PUT
    #   :residence_permit_at
    # Ha Utskriven till Malmö
    #   :checked_out_to_our_city
    # inte ha medborgarskap
    #   :citizenship_at
    #
    # Från-datum beräknas på senaste datum av följande:
    #   datumet när barnet uppnått minimiålder
    #     :date_of_birth
    #   startdatum för PUT
    #     :residence_permit_at
    #   utskriven till Malmö - 1 dag
    #     :checked_out_to_our_city
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   datumet när barnet uppnått maxålder + 1 år – 1 dag
    #   avslutsdatum - 1
    #     :deregistered
    #   medborgarskap erhölls - 1 dag
    #     :citizenship_at
    # Returns the number of days for the rate and the rate amount
    def residence_permit(category)
      return [] if
        @refugee.residence_permit_at.nil? ||
        @refugee.checked_out_to_our_city.nil? ||
        @refugee.citizenship_at?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(category, rate),
          @refugee.residence_permit_at,
          day_before(@refugee.checked_out_to_our_city)
        )

        to = earliest_date(
          *shared_to_attr(category, rate),
          day_before(@refugee.deregistered),
          @refugee.citizenship_at
        )

        amount_and_days(from, to, rate)
      end
    end

    private

    # Takes the arguments from and to for the qualified rate period and the rate object
    # Returns a hash with :amount and :days for the rate
    def amount_and_days(from, to, rate, options = {})
      return unless from && to

      days = number_of_remaining_days_with_exempt_from_rate_deducted(from, to, skip_replace: options[:skip_replace])
      return if days.zero?

      { amount: rate.amount, days: days }
    end

    # Takes the arguments from and to for a rate period
    #   and deducts days within the period that must not be calulate for rate
    #   See doc in Economy::ReplaceRatesWithActualCosts
    # Returns the number of qualified days for the rate
    def number_of_remaining_days_with_exempt_from_rate_deducted(from, to, options = {})
      # Create a range of dates in the rate period and convert it to an array
      days_with_rate = (from.to_date..to.to_date).to_a

      return days_with_rate.size if options[:skip_replace]

      # Deduct the exempt_from_rate days array from the rate days array
      #   to get rate qualified days.
      # Return the number qualified days by reducing the
      #   days_with_rate with the exempt_days_array
      (days_with_rate - @replace_rates.exempt_days_array).size
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

      # Special case: the date when the age is 20 is the last of June
      # the year the refugee becomes 20
      return Date.new(date_of_birth.year + 20, 6, 30) if age == 20

      date_of_birth + age.years + 1.years - 1.day
    end
  end
end
