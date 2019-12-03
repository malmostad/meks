class EconomyUppbokningReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params

    options = {}
    options[:locals] = { statuses: statuses }
    super(options.merge(params))
  end

  private

  # People with combination of given rate categories and legal codes
  def statuses
    @people = people

    # Rate categories ("Schablonkategorier")
    assigned_0_17   = RateCategory.where(name: 'assigned_0_17').first
    tut_0_17        = RateCategory.where(name: 'temporary_permit_0_17').first
    put_0_17        = RateCategory.where(name: 'residence_permit_0_17').first
    tut_18_20       = RateCategory.where(name: 'temporary_permit_18_20').first
    put_18_20       = RateCategory.where(name: 'residence_permit_18_20').first
    arrival_0_17    = RateCategory.where(name: 'arrival_0_17').first

    # People with placements with specific legal codes by ID(s) ("Lagrum")
    sol             = people_with_legal_code(1)
    lvu_and_sol_lvu = people_with_legal_code(2, 3)

    [
      {
        name: 'SoL, Anvisade barn, 0–17',
        records: per_rate_category(sol, assigned_0_17)
      },
      {
        name: 'SoL, PUT+TUT, 0–17',
        records: per_rate_category(sol, tut_0_17, put_0_17)
      },
      {
        name: 'SoL, PUT+TUT, 18–20',
        records: per_rate_category(sol, tut_18_20, put_18_20)
      },
      {
        name: 'LVU+SoL med LVU, Anvisade 0–17',
        records: per_rate_category(lvu_and_sol_lvu, assigned_0_17)
      },
      {
        name: 'LVU+SoL med LVU, PUT+TUT 0–17',
        records: per_rate_category(lvu_and_sol_lvu, put_0_17, tut_0_17)
      },
      {
        name: 'LVU+SoL med LVU, PUT+TUT 18–20',
        records: per_rate_category(lvu_and_sol_lvu, put_18_20, tut_18_20)
      },
      {
        name: 'Alla lagrum, Ankomstbarn, 0–17',
        records: per_rate_category(@people, arrival_0_17)
      },
      {
        name: 'Anvisningsschablon',
        records: Economy::OneTimePayment.all(from: @params[:from], to: @params[:to]),
        one_type_payments: true
      }
    ]
  end

  # Returns and array with the given people with a hash for each person
  # containing the Economy::RatesForPerson data of the given rate categories
  # with the person record and date interval added.
  # People that don't fall into any rate category are ignored.
  def per_rate_category(people, *categories)
    people.map do |person|
      interval = qualified_interval(person)
      rates_for_person = ::Economy::RatesForPerson.new(person, interval)

      rates = categories.map do |category|
        rates_for_person.send(category.qualifier[:meth], category)
      end.flatten.compact

      next if rates.empty?

      { person: person, rates: as_formula(rates), days: sum_days(rates) }
    end.reject(&:blank?)
  end

  def people
    Person
      .references(:placements)
      .includes(
        :ssns, :dossier_numbers,
        :municipality,
        :person_extra_costs, :extra_contributions,
        placements: [:legal_code, :placement_extra_costs, :family_and_emergency_home_costs,
                     home: [:costs]]
      )
      .where(ekb: true)
      .where('placements.moved_in_at <= ?', @params[:to])
      .where('placements.moved_out_at is ? or placements.moved_out_at >= ?', nil, @params[:from])
  end

  # Returns people from our municipality
  # with placements that matches the given id(s) for legal code(s)
  def people_with_legal_code(*ids)
    @people.where(municipalities: { our_municipality: true })
             .where(placements: { legal_code: ids })
  end

  # Returns a hash with the date interval a person is qualified.
  # The interval is cut of with the report interval
  def qualified_interval(person)
    # The max range the person qualifies for the legal code(s)
    qualified_from = earliest_date(person.placements.map(&:moved_in_at))

    # Use @params[:to] if the person has an open ended placement
    if person.placements.map(&:moved_out_at).include? nil
      qualified_to = @params[:to]
    else
      qualified_to = latest_date(person.placements.map(&:moved_out_at))
    end

    # Cut of the qualified range with the report range to get the actual range
    {
      from: latest_date(qualified_from, @params[:from]),
      to: earliest_date(qualified_to, @params[:to])
    }
  end

  def as_formula(rates)
    rates.map do |rate|
      next rate.to_s if rate.is_a? BigDecimal

      next "#{rate[:days]}*#{rate[:amount]}" if days_hash?(rate)
      next "#{rate[:months]}*#{rate[:costs]}" if months_hash?(rate)
      next "#{rate[:months]}*(#{rate[:fee]}+#{rate[:po_cost]}+#{rate[:expense]})" if po_cost_hash?(rate)
    end.compact.join('+')
  end

  def sum_days(rates)
    rates.map do |rate|
      next if rate.is_a? BigDecimal

      rate[:days] if days_hash?(rate)
    end.compact.sum
  end

  def days_hash?(hash)
    test_hash([hash[:days], hash[:amount]], hash[:days])
  end

  def months_hash?(hash)
    test_hash([hash[:months], hash[:costs]], hash[:months])
  end

  def po_cost_hash?(hash)
    test_hash([hash[:months], hash[:fee], hash[:po_cost]], hash[:months])
  end

  def test_hash(arr, int)
    arr.is_a?(Array) && !arr.include?(nil) && int.positive?
  end
end
