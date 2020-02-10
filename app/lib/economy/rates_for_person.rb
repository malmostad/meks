module Economy
  # Person rates (förväntade intäkter)
  # Comments in Swedish from project specs
  class RatesForPerson < Base
    attr_reader :replace_rates

    def initialize(person, interval)
      @person = person
      @interval = interval
      @rate_categories_and_rates = RateCategory.all_cached
    end

    # Sum for self and ReplaceRatesWithActualCosts
    def sum
      as_array.map do |x|
        next x if x.is_a? BigDecimal

        next x[:days] * x[:amount] if days_hash?(x)
        next x[:months] * x[:costs] if months_hash?(x)
        next x[:months] * (x[:fee] + x[:po_cost] + x[:expense]) if po_cost_hash?(x)
      end.compact.sum
    end

    # Formula for self and ReplaceRatesWithActualCosts
    def as_formula
      as_array.map do |x|
        next x.to_s if x.is_a? BigDecimal

        next "#{x[:days]}*#{x[:amount]}" if days_hash?(x)
        next "#{x[:months]}*#{x[:costs]}" if months_hash?(x)
        next "#{x[:months]}*(#{x[:fee]}+#{x[:po_cost]}+#{x[:expense]})" if po_cost_hash?(x)
      end.compact.join('+')
    end

    # Returns the number of days for the rate and the rate amount
    def as_array
      return [] unless @person.ekb?

      @as_array ||= begin
        @rate_categories_and_rates.map do |category|
          send(category.qualifier[:meth], category)
        end.flatten.compact
      end
    end

    # Utility method for debugging.
    # Returns an hash with each rate category and the amount and days qualified
    def qualifies_as(skip_all_replace = true)
      return {} unless @person.ekb?

      @skip_all_replace = skip_all_replace

      @rate_categories_and_rates.map do |category|
        [category.qualifier.values.join('_'), send(category.qualifier[:meth], category).flatten.compact]
      end.to_h
    end

    # Schablonkategori Ankomstbarn
    #
    # Måste:
    #   ha inskrivningsdatum
    #     :registered
    #
    # Från-datum beräknas på senaste datum av följande:
    #    datumet när personen uppnått minimiålder
    #      :date_of_birth
    #    inskrivningsdatum
    #      :registered
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   datumet när personen uppnått maxålder + 1 år – 1 dag
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
      return [] if @person.registered.nil?

      category.rates.map do |rate|
        interval = interval_for_arrival_0_17(category, rate)
        next unless interval[:from] && interval[:to]

        days = (interval[:to].to_date - interval[:from].to_date + 1).to_i
        next if days.zero?

        # The arrival rate category must not have actual cost replaced
        { amount: rate.amount, days: days }
      end
    end

    def interval_for_arrival_0_17(category, rate = {})
      return {} if @person.citizenship_at? || @person.registered.nil?

      from = latest_date(
        *shared_from_attr(category, rate),
        @person.registered
      )

      return {} if from.nil?

      to = earliest_date(
        *shared_to_attr(category, rate),
        day_before(@person.deregistered),
        day_before(@person.municipality_placement_migrationsverket_at),
        @person.temporary_permit_starts_at,
        @person.residence_permit_at,
        day_before(@person.citizenship_at)
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
    #   datumet när personen uppnått minimiålder
    #     :date_of_birth
    #   anvisningdatum
    #     :municipality_placement_migrationsverket_at
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   datumet när personen uppnått maxålder + 1 år – 1 dag
    #     :date_of_birth
    #   utskriven till Malmö
    #     :checked_out_to_our_city
    #   avslutad - 1 dag
    #     :deregistered
    #  medborgarskap erhölls - 1 dag
    #     :citizenship_at
    # Returns the number of days for the rate and the rate amount
    def assigned_0_17(category)
      return [] if !@person.in_our_municipality?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(category, rate),
          @person.municipality_placement_migrationsverket_at
        )

        to = earliest_date(
          *shared_to_attr(category, rate),
          @person.checked_out_to_our_city,
          day_before(@person.deregistered),
          day_before(@person.citizenship_at)
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
    #   datumet när personen uppnått minimiålder
    #     :date_of_birth
    #   utskriven till Malmö
    #     :checked_out_to_our_city
    #   startdatum för TUT
    #     :temporary_permit_starts_at
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   datumet när personen uppnått maxålder + 1 år – 1 dag
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
          @person.temporary_permit_starts_at.nil? ||
          @person.temporary_permit_ends_at.nil? ||
          @person.temporary_permit_ends_at - @person.temporary_permit_starts_at < 365 ||
          @person.checked_out_to_our_city.nil?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(category, rate),
          @person.checked_out_to_our_city,
          @person.temporary_permit_starts_at
        )

        to = earliest_date(
          *shared_to_attr(category, rate),
          @person.temporary_permit_ends_at,
          @person.residence_permit_at,
          day_before(@person.deregistered),
          day_before(@person.citizenship_at)
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
    #
    # Från-datum beräknas på senaste datum av följande:
    #   datumet när personen uppnått minimiålder
    #     :date_of_birth
    #   startdatum för PUT
    #     :residence_permit_at
    #   utskriven till Malmö
    #     :checked_out_to_our_city
    #
    # Till-datum beräknas på tidigaste datum av följande:
    #   datumet när personen uppnått maxålder + 1 år – 1 dag
    #   avslutsdatum - 1
    #     :deregistered
    #   medborgarskap erhölls - 1 dag
    #     :citizenship_at
    # Returns the number of days for the rate and the rate amount
    def residence_permit(category)
      return [] if
        @person.residence_permit_at.nil? ||
        @person.checked_out_to_our_city.nil?

      category.rates.map do |rate|
        from = latest_date(
          *shared_from_attr(category, rate),
          @person.residence_permit_at,
          @person.checked_out_to_our_city
        )

        to = earliest_date(
          *shared_to_attr(category, rate),
          day_before(@person.deregistered),
          @person.citizenship_at
        )

        amount_and_days(from, to, rate)
      end
    end

    private

    # Takes the arguments from and to for the qualified rate period and the rate object
    # Returns a hash with :amount and :days for the rate
    def amount_and_days(from, to, rate)
      return unless from && to

      days = number_of_remaining_days_with_exempt_from_rate_deducted(from, to, skip_replace: @skip_all_replace)

      if @skip_all_replace
        [{ amount: rate.amount, days: days }]
      else
        # Special case. date_at_max_age has max age set to 30 june for those of age 20
        # but that must not apply to replacement with actual cost.
        to = end_date_for_replacement_at_20(rate) if rate.rate_category.qualifier[:max_age] == 20

        @replace_rates = ReplaceRatesWithActualCosts.new(@person, from: from, to: to)
        return @replace_rates.as_array if days.zero?

        [{ amount: rate.amount, days: days }] + @replace_rates.as_array
      end
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
      @replace_rates = ReplaceRatesWithActualCosts.new(@person, from: from, to: to)

      (days_with_rate - @replace_rates.exempt_days_array).size
    end

    def shared_from_attr(category, rate)
      [
        date_at_min_age(@person.date_of_birth, category.qualifier[:min_age]),
        @interval[:from],
        rate[:start_date]
      ]
    end

    def shared_to_attr(category, rate)
      [
        date_at_max_age(@person.date_of_birth, category.qualifier[:max_age]),
        @interval[:to],
        rate[:end_date]
      ]
    end

    def end_date_for_replacement_at_20(rate)
      earliest_date(
        @person.date_of_birth + 21.years - 1.day,
        @interval[:to],
        rate[:end_date]
      )
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
      # the year the person becomes 20
      return Date.new(date_of_birth.year + 20, 6, 30) if age == 20

      date_of_birth + age.years + 1.years - 1.day
    end
  end
end
