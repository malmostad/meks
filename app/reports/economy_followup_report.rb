class EconomyFollowupReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params
    @refugees = refugees
    @year = params[:year].to_i

    options = {}
    options[:sheet_name] = params[:year]
    options[:locals] = { children: children, adults: adults }
    super(options.merge(params))
  end

  # Under 18 on the first day of given year
  def children
    @refugees.where('date_of_birth >= ?', Date.new(@year - 18))
  end

  # Over 18 on the last day of given year
  def adults
    @refugees.where('date_of_birth <= ?', Date.new(@year - 18).end_of_year)
  end

  private

  def refugees
    Refugee.includes(:municipality, current_placements: [home: :type_of_housings])
    # .limit(100).order('id desc')
  end
end
