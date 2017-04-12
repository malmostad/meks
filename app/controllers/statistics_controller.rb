class StatisticsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  before_action { authorize! :view, :statistics }

  def index
    @refugees = Rails.cache.fetch("queries-#{cache_key_for_status}") do
      [
        "#{registered.count} antal barn är i ankomst i väntan på anvisning",
        "Malmö SRF ansvarar för #{refugees_srf.count} antal barn, varav #{refugees_srf_men.count} är pojkar och #{refugees_srf_women.count} är flickor",
        "Vanligaste nationaliteterna (10 barn eller fler, visa de 3 vanligaste nationaliteterna)",
        "X antal är asylsökande och väntar på beslut i asylärendet",
        "X antal har PUT",
        "X antal har TUT",
        "X antal har erhållit svenskt medborgarskap"
      ]
    end

    @placements_homes = Rails.cache.fetch("queries-#{cache_key_for_status}") do
      [
        "X antal barn är placerade på kommunala HVB",
        "X antal barn är externt placerade",
        "X antal barn är placerade i jourhem",
        "X antal barn är placerade i familjehem",
        "X antal barn är placerade på utslussboende",
        "X antal barn tillhörande Malmös stadsområden är placerade på SRF:s boenden",
        "Det finns X boenden med X antal boendeplatser. På samtliga boenden finns det totalt X antal tomma platser"
      ]
    end
  end

  private

  # "I ankomst i väntan på anvisning"
  def registered
    Refugee.where.not(registered: nil)
      .where(deregistered: nil)
      .where(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(sof_placement: false)
      .where.not(municipality_id: 135) # 135 is hardcoded "Malmö kommun, Srf"
  end

  # "Malmö SRF ansvarar för X antal barn"
  def refugees_srf
    Refugee.where.not(municipality_id: 135)
      .where(deregistered: nil) # 135 is hardcoded "Malmö kommun, Srf"
  end

  def refugees_srf_women
    refugees_srf.where(gender_id: 1) # 1 is hardcoded women
  end

  def refugees_srf_men
    refugees_srf.where(gender_id: 2) # 2 is hardcoded men
  end

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
