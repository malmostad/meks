class EconomyFollowupReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params
    @year = params[:year].to_i
    @refugees = refugees

    options = {}
    options[:sheet_name] = params[:year]
    options[:locals] = { children: children, adults: adults, year: @year, po_rates: PoRate.all }

    super(options.merge(params))
  end

  # Under 18 on the first day of given year
  def children
    @refugees.where('refugees.date_of_birth > ?', Date.new(@year - 18))
  end

  # Over 18 on the last day of given year
  def adults
    @refugees.where('refugees.date_of_birth <= ?', Date.new(@year - 18).end_of_year)
  end

  private

  # Returns all refugees with placements within the @year
  def refugees
    Refugee.includes(
      :municipality,
      :refugee_extra_costs, :extra_contributions,
      placements: [:legal_code, :placement_extra_costs, :family_and_emergency_home_costs,
                   home: [:owner_type, :type_of_housings, :costs]]
    )
  end
end
