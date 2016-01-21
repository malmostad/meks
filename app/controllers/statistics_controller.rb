class StatisticsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  before_action { authorize! :view, :statistics }

  def index
    @stats = Rails.cache.fetch("queries-#{cache_key_for_status}") do
      {
        periods: [
          {title: 'Inskrivna detta år', data: stats_for_collection(registered_this_year)},
          {title: 'Inskrivna detta kvartal', data: stats_for_collection(registered_this_quarter)}
        ],
        homes: Home.count,
        seats: Home.sum(:seats),
        guaranteed_seats: Home.sum(:guaranteed_seats),
        movable_seats: Home.sum(:movable_seats),
        total_placement_time: Placement.all.map(&:placement_time).inject(&:+)
      }
    end
  end

  private

  def stats_for_collection(collection)
    {
      refugees: collection.count,
      per_gender: Gender.all.map { |g| "#{collection.where(gender: g).count} är #{g.name.downcase}" }.join(', '),
      deregistered: collection.where.not(deregistered: nil).count,
      with_residence_permit: collection.where.not(residence_permit_at: nil).count,
      with_temporary_permit: collection.where.not(temporary_permit_starts_at: nil).count,
      with_placement: collection.includes(:placements).where.not(placements: { refugee_id: nil }).count,
      with_municipality_placement: collection.where.not(municipality: nil).count,
      top_countries: collection.joins(:countries).select('countries.name').group('countries.name').count('countries.name').sort_by{ |key, value| value }.reverse,
      top_languages: collection.joins(:languages).select('languages.name').group('languages.name').count('languages.name').sort_by{ |key, value| value }.reverse,
    }
  end

  private

  def registered_this_year
    @registered_this_year ||=
      Refugee.where('registered >= ?', Date.today.beginning_of_year)
  end

  def registered_this_quarter
    @registered_this_quarter ||=
      Refugee.where('registered >= ?', Date.today.beginning_of_quarter)
  end

  def cache_key_for_status
    @cache_key_for_status ||=
      count = Refugee.count + Home.count + Placement.count
      latest_update = [
        Refugee.maximum(:updated_at),
        Home.maximum(:updated_at),
        Placement.maximum(:updated_at)].sort.last.try(:utc).try(:to_s, :number)
      "status/index-#{Date.today.to_s}-#{count}-#{latest_update}"
  end
end
