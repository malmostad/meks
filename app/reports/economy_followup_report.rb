class EconomyFollowupReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params
    @year = params[:year].to_i
    @refugees = refugees

    options = {}
    options[:sheet_name] = params[:year]
    options[:locals] = { children: children, adults: adults, year: @year, po_rates: PoRate.all }

    Rails.logger.debug "XYEAR: #{@year}"
    Rails.logger.debug "XSHEETNAME: #{options[:sheet_name]}"
    Rails.logger.debug "XOPTIONS: #{options}"

    super(options.merge(params))
  end

  # Under 18 on the first day of given year
  def children
    @refugees.where('refugees.date_of_birth >= ?', Date.new(@year - 18))
  end

  # Over 18 on the last day of given year
  def adults
    @refugees.where('refugees.date_of_birth <= ?', Date.new(@year - 18).end_of_year)
  end

  private

  # Returns all refugees with placements within the @year
  def refugees
    date = Date.new(@year)
    Refugee.with_placements_within(date.beginning_of_year.to_s, date.end_of_year.to_s)
  end
end
