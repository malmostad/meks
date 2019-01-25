class EconomyFollowupReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params

    options = {}
    options[:sheet_name] = params[:year]
    options[:locals] = { refugees: refugees }
    super(options.merge(params))
  end

  def refugees
    Refugee.limit(25)
  end
end
