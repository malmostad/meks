class StatisticsController < ApplicationController
  def index
    @refugees = Refugee.count
    @genders = Gender.all.map { |g| "#{Refugee.where(gender: g).count} är #{g.name.downcase}" }.join(', ')
    @registered_last_seven_days = Refugee.where(registered: 7.days.ago..DateTime.now).count

    @without_placement = Refugee.includes(:placements).where(placements: { refugee_id: nil }).count
    @without_residence_permit = Refugee.where(residence_permit_at: nil).count
    @without_municipality_placement = Refugee.where(municipality: nil).count
    @deregistered = Refugee.where.not(deregistered: nil).count

    @homes = Home.count
    @total_placement_time = Placement.all.map(&:placement_time).inject(&:+)
  end
end
