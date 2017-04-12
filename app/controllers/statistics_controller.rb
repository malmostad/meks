class StatisticsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  before_action { authorize! :view, :statistics }

  def index
  end

  private

  def registered
    Refugee.where.not(registered: nil)
      .where(deregistered: nil)
      .where(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(sof_placement: false)
      .where.not(municipality_id: 135) # 135 is hardcoded "Malmö kommun, Srf"
  end
  helper_method :registered

  def srf
    Refugee.where(municipality_id: 135) # 135 is hardcoded "Malmö kommun, Srf"
      .where(deregistered: nil)
  end
  helper_method :srf

  def srf_women
    srf.where(gender_id: 1) # 1 is hardcoded women
  end
  helper_method :srf_women

  def srf_men
    srf.where(gender_id: 2) # 2 is hardcoded men
  end
  helper_method :srf_men

  def top_countries
    srf.joins(:countries).select('countries.name')
      .group('countries.name')
      .count('countries.name')
      .sort_by{ |key, value| value }.reject { |k, v| v <= 10  }.reverse[0...3].map(&:first).join(', ')
  end
  helper_method :top_countries

  def waiting_for_verdict
    srf.where(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(citizenship_at: nil)
  end
  helper_method :waiting_for_verdict

  def residence_permit
    srf.where(temporary_permit_starts_at: nil)
      .where(citizenship_at: nil)
  end
  helper_method :residence_permit

  def temporary_permit
    srf.where(residence_permit_at: nil)
      .where(citizenship_at: nil)
  end
  helper_method :temporary_permit

  def citizenship
    srf.where.not(citizenship_at: nil)
  end
  helper_method :citizenship



  def cache_key_for_status
    @cache_key_for_status ||=
      count = Refugee.count + Home.count + Placement.count
      latest_update = [
        Refugee.maximum(:updated_at),
        Home.maximum(:updated_at),
        Placement.maximum(:updated_at)].reject(&:blank?).sort.last.try(:utc).try(:to_s, :number)
      "status/index-#{Date.today.to_s}-#{count}-#{latest_update}"
  end
end
