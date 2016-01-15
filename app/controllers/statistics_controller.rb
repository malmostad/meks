class StatisticsController < ApplicationController
  def index
    @stats = Rails.cache.fetch("queries-#{cache_key_for_status}") do
      {
        refugees: Refugee.count,
        genders: Gender.all.map { |g| "#{Refugee.where(gender: g).count} är #{g.name.downcase}" }.join(', '),
        registered_last_seven_days: Refugee.where(registered: 7.days.ago..DateTime.now).count,
        genders_last_seven_days: Gender.all.map { |g| "#{Refugee.where(gender: g, registered: 7.days.ago..DateTime.now).count} är #{g.name.downcase}" }.join(', '),

        without_placement: Refugee.includes(:placements).where(placements: { refugee_id: nil }).count,
        overlapping_placement: Placement.overlapping_by_refugee.count,
        overlapping_placement_last_seven_days: Placement.overlapping_by_refugee(placements_from: 170.days.ago.to_s, placements_to: Date.today.to_s).count,

        without_residence_permit: Refugee.where(residence_permit_at: nil).count,
        without_municipality_placement: Refugee.where(municipality: nil).count,
        deregistered: Refugee.where.not(deregistered: nil).count,

        top_countries: Refugee.joins(:countries).select('countries.name').group('countries.name').count('countries.name').sort_by{ |key, value| value }.reverse,
        top_countries_last_seven_days: Refugee.joins(:countries).where(registered: 7.days.ago..DateTime.now).select('countries.name').group('countries.name').count('countries.name').sort_by{ |key, value| value }.reverse,

        top_languages: Refugee.joins(:languages).select('languages.name').group('languages.name').count('languages.name').sort_by{ |key, value| value }.reverse,
        top_languages_last_seven_days: Refugee.joins(:languages).where(registered: 7.days.ago..DateTime.now).select('languages.name').group('languages.name').count('languages.name').sort_by{ |key, value| value }.reverse,

        homes: Home.count,
        seats: Home.sum(:seats),
        guaranteed_seats: Home.sum(:guaranteed_seats),
        movable_seats: Home.sum(:movable_seats),
        total_placement_time: Placement.all.map(&:placement_time).inject(&:+)
      }
    end
  end

  def cache_key_for_status
    @cache_key_for_status ||=
      count = Refugee.count + Home.count + Placement.count
      latest_update = [
        Refugee.maximum(:updated_at),
        Home.maximum(:updated_at),
        Placement.maximum(:updated_at)].sort.last.try(:utc).try(:to_s, :number)
      "status/index-#{count}-#{latest_update}"
  end
end
