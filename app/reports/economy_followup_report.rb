class EconomyFollowupReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params
    @year = params[:year].to_i
    @people = people

    options = {}
    options[:sheet_name] = params[:year]
    options[:locals] = { children: children, adults: adults, year: @year, po_rates: PoRate.all }

    super(options.merge(params))
  end

  # Under 18 on the first day of given year
  def children
    @people.where('people.date_of_birth > ?', Date.new(@year - 18))
  end

  # Over 18 on the last day of given year
  def adults
    @people.where('people.date_of_birth <= ?', Date.new(@year - 18).end_of_year)
  end

  private

  # Returns all people with placements within the @year
  def people
    Person
      .includes(
        :municipality,
        :person_extra_costs,
        extra_contributions: :extra_contribution_type,
        placements: [:legal_code, :placement_extra_costs, :family_and_emergency_home_costs,
                     home: [:owner_type, :type_of_housings, :costs]]
      )
      .where('registered <= ?', Date.new(@year).end_of_year)
      .where('not deregistered < ? or deregistered is ?', Date.new(@year).beginning_of_year, nil)
      .where('not citizenship_at < ? or citizenship_at is ?', Date.new(@year).beginning_of_year, nil)
  end
end
