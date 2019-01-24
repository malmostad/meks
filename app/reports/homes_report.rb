class HomesReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params

    options = { sheet_name: 'Boenden' }
    options[:locals] = { homes: homes }
    super(options.merge(params))
  end

  def homes
    query = Home.includes(
      :placements, :type_of_housings,
      :owner_type, :target_groups, :languages
    )

    query = query.where(owner_type: @params[:owner_type]) if @params[:owner_type].present?
    query = query.each.reject { |r| r.free_seats <= 0 } if @params[:free_seats] == 'with'
    query
  end
end
