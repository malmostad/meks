class EconomyUppbokningReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params

    options = {}
    options[:locals] = { statuses: statuses }
    super(options.merge(params))
  end

  # private

  # Refugees with combination of given rate categories and legal codes
  def statuses
    # Rate categories ("Schablonkategorier")
    assigned_0_17   = RateCategory.where(name: 'assigned_0_17').first
    tut_0_17        = RateCategory.where(name: 'temporary_permit_0_17').first
    put_0_17        = RateCategory.where(name: 'residence_permit_0_17').first
    tut_18_20       = RateCategory.where(name: 'temporary_permit_18_20').first
    put_18_20       = RateCategory.where(name: 'residence_permit_18_20').first
    arrival_0_17    = RateCategory.where(name: 'arrival_0_17').first

    # Refugees with placements with specific legal codes by ID(s) ("Lagrum")
    sol             = refugees_with_legal_code(1)
    lvu_and_sol_lvu = refugees_with_legal_code(2, 3)
    all             = refugees_with_legal_code # All refugees

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
        name: 'LVU+SoL med LVU, PUT 0–17',
        records: per_rate_category(lvu_and_sol_lvu, tut_0_17, put_0_17)
      },
      {
        name: 'LVU+SoL med LVU, PUT 18–20',
        records: per_rate_category(lvu_and_sol_lvu, tut_18_20, put_18_20)
      },
      {
        name: 'Alla lagrum, Ankomstbarn, 0–17',
        records: per_rate_category(all, arrival_0_17)
      }
    ]
  end

  # Returns and array with the given refugees with a hash for each refugee
  # containing the Economy::RatesForRefugee data of the given rate categories
  # with the refugee record and date interval added.
  # Refugees that don't fall into any rate category are ignored.
  def per_rate_category(refugees, *categories)
    refugees.map do |refugee|
      interval = qualified_interval(refugee)
      rates_for_refugee = ::Economy::RatesForRefugee.new(refugee, interval)

      days_and_amounts = categories.map do |category|
        rates_for_refugee.send(category.qualifier[:meth], category)
      end.flatten.compact

      next if days_and_amounts.empty?

      { refugee: refugee, rates: days_and_amounts }.merge(interval)
    end.reject(&:blank?)
  end

  # Returns refugees with placements that matches the given id(s) for legal code(s)
  def refugees_with_legal_code(*ids)
    refugees =
      Refugee
      .includes(
        :ssns, :dossier_numbers,
        :municipality,
        :refugee_extra_costs, :extra_contributions,
        placements: [:legal_code, :placement_extra_costs, :family_and_emergency_home_costs,
                     home: [:costs]]
      )
      .where(municipalities: { our_municipality: true })
      .where('placements.moved_in_at <= ?', @params[:to])
      .where('placements.moved_out_at is ? or placements.moved_out_at >= ?', nil, @params[:from])

    return refugees.where(placements: { legal_code: ids }) unless ids.blank?

    refugees
  end

  # Returns a hash with the date interval a refugee is qualified.
  # The interval is cut of with the report interval
  def qualified_interval(refugee)
    # The max range the refugee qualifies for the legal code(s)
    qualified_from = earliest_date(refugee.placements.map(&:moved_in_at))
    qualified_to   = latest_date(refugee.placements.map(&:moved_out_at))

    # Cut of the qualified range with the report range to get the actual range
    {
      from: latest_date(qualified_from, @params[:from]),
      to: earliest_date(qualified_to, @params[:to])
    }
  end
end
