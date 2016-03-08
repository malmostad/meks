class StatisticsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  before_action { authorize! :view, :statistics }

  def index
    data = [['X', 'antal barn']]
    registered_per_day(7.day.ago..1.day.ago).each do |date, quantity|
      data << [I18n.l(date, format: :short), quantity]
    end

    @chart = {
      id: 'weekly',
      title: 'Antal nyanlända barn senaste sju dagarna',
      data: data
    }

    @stats = Rails.cache.fetch("queries-#{cache_key_for_status}") do
      {
        periods: [
          { id: 'all',
            title: 'Aktuella ärenden just nu',
            data: stats_for_collection(all_registered),
          },
          { id: 'this-month',
            title: 'Nyinskrivna aktuell månad',
            data: stats_for_collection(registered_this_month)
          },
          { id: 'this-year',
            title: 'Nyinskrivna detta år',
            data: stats_for_collection(registered_this_year) }
        ],

        homes: Home.where(active: true).count,
        home_by_owner_type: OwnerType.all.map { |ot|
          "#{Home.where(active: true, owner_type: ot).count} är #{ot.name}" }.join(', '),

        current_placed_refugees: Placement.where(moved_out_at: nil).select(:refugee_id).distinct,
        current_placements: Placement.current_placements,
        current_placements_per_owner_type: OwnerType.all.map { |ot|
          "#{Placement.current_placements.includes(:home).where(
            homes: { active: true, owner_type_id: ot.id }).count} på #{ot.name}" }.join(', '),

        guaranteed_seats: Home.where(active: true).sum(:guaranteed_seats),
        movable_seats: Home.where(active: true).sum(:movable_seats),
      }
    end
  end

  private

  def stats_for_collection(collection)
    malmo_srf = collection.joins(:municipality).where("municipalities.name like ?", "malmö%srf").count
    malmo_total = collection.joins(:municipality).where("municipalities.name like ?", "malmö%").count
    {
      refugees: collection.count,
      per_gender: Gender.all.map { |g| "#{collection.where(gender: g).count} är #{g.name.downcase}" }.join(', '),
      in_transit: collection.where(
          residence_permit_at: nil,
          temporary_permit_starts_at: nil,
          municipality: nil,
          municipality_placement_migrationsverket_at: nil,
          municipality_placement_per_agreement_at: nil,
          deregistered: nil).count,
      with_residence_permit: collection.where.not(residence_permit_at: nil).count,
      with_municipality_placement_in_malmo_srf: malmo_srf,
      with_municipality_placement_in_malmo_sdo: malmo_total - malmo_srf,
      with_municipality_placement_others: collection.where.not(municipality: nil).count - malmo_total,
      with_no_municipality_placement: collection.where(municipality: nil).count,
      at_external_home: Placement.includes(:home).where(refugee: collection, moved_out_at: nil, homes: { owner_type_id: 3 }).select(:refugee_id).distinct.count,
      top_countries: collection.joins(:countries).select('countries.name').group('countries.name').count('countries.name').sort_by{ |key, value| value }.reject { |k, v| v <= 10  }.reverse
    }
  end

  def all_registered
    @all_registered ||= Refugee.all
  end

  def registered_this_year
    @registered_this_year ||=
      Refugee.where('registered >= ?', Date.today.beginning_of_year)
  end

  def registered_this_quarter
    @registered_this_quarter ||=
      Refugee.where('registered >= ?', Date.today.beginning_of_quarter)
  end

  def registered_this_month
    @registered_this_month ||=
      Refugee.where('registered >= ?', Date.today.beginning_of_month)
  end

  def registered_last_week
    @registered_last_week ||=
      one_week_ago = Date.today - 1.week
      Refugee.where(registered: one_week_ago.beginning_of_week..one_week_ago.end_of_week)
  end

  def registered_per_day(range)
    Refugee.where(registered: range).select('registered').group('registered').count('registered')
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
