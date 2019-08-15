class PlacementsReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params

    options = {}
    options[:locals] = { placements: placements }
    super(options.merge(params))
  end

  def placements
    query = Placement.within_range(@params[:from], @params[:to])

    # Selected one home or all
    if @params[:home_id].present? && @params[:home_id].reject(&:empty?).present?
      query = query.where(home_id: @params[:home_id])
    end

    # Select overlapping placements per person
    if @params[:selection] == 'overlapping'
      query = query.overlapping_by_person(@params[:from], @params[:to])
    end

    query.find_each.lazy
  end
end
