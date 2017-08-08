class StatisticsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  before_action { authorize! :view, :statistics }

  def index
    @cache_key_for_status = cache_key_for_status
  end

  private

  def cache_key_for_status
    count = Refugee.count + Home.count + Placement.count + Setting.count
    latest_update = [
      Refugee.maximum(:updated_at),
      Home.maximum(:updated_at),
      Setting.maximum(:updated_at),
      Placement.maximum(:updated_at)
    ].reject(&:blank?).sort.last.try(:utc).try(:to_s, :number)
    "status/index-#{Date.today}-#{count}-#{latest_update}"
  end
end
