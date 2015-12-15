class StatisticsController < ApplicationController
  def index
    @refugees = Refugee.count
    @genders = Gender.all.map { |g| "#{Refugee.where(gender: g).count} är #{g.name.downcase}" }.join(', ')

    @without_placement = Refugee.includes(:placements).where(placements: { refugee_id: nil }).count
    @without_residence_permits = 123   # Refugee.where(residence_permit: nil).count
    @without_municipality_placement = 123 # Refugee.where(municipality_placement: nil).count
    @deregistered = Refugee.where.not(deregistered: nil).count

    @homes = Home.count
    @total_placement_time = Placement.all.map(&:placement_time).inject(&:+)
  end
end
