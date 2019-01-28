class EconomyReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params

    options = {}
    options[:locals] = { refugees: refugees, po_rates: PoRate.all }
    super(options.merge(params))
  end

  # Returns all refugees with placements within the interval
  def refugees
    Refugee.with_placements_within(@params[:from], @params[:to])
  end
end
