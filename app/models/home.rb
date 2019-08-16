# 'Boende'
class Home < ApplicationRecord
  # Each home is of one of those types.
  # :cost_per_day is set on the home ('Dygnskostnad')
  # :cost_per_placement is set once on placements ('Placeringskostnad')
  # :cost_for_family_and_emergency_home are multiple costs set on plcements ('Familje/jourhemskostnad')
  enum type_of_cost: %i[
    cost_per_day
    cost_per_placement
    cost_for_family_and_emergency_home
  ]

  has_many :placements, dependent: :destroy
  has_many :people, through: :placements

  has_many :costs, dependent: :destroy
  accepts_nested_attributes_for :costs, allow_destroy: true
  validates_associated :costs

  has_and_belongs_to_many :type_of_housings
  has_and_belongs_to_many :target_groups
  has_and_belongs_to_many :languages
  belongs_to :owner_type

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name, :type_of_cost
  validates_length_of :name, maximum: 191

  # Remove data not allowed for the home and it's placements
  before_save do
    costs.destroy_all unless cost_per_day? # Based on Home#type_of_cost

    placements.each do |placement|
      placement.update_attribute(:specification, nil) unless use_placement_specification?

      # Based on Home#type_of_cost
      placement.update_attribute(:cost, nil) unless cost_per_placement?
      placement.family_and_emergency_home_costs.destroy_all unless cost_for_family_and_emergency_home?
    end
  end

  after_save do
    # Rollback transaction if cost date ranges overlaps
    validate_associated_date_overlaps(costs, :amount)
  end

  default_scope { order(:name) }

  def current_placements
    placements.where(moved_out_at: nil)
  end

  def number_of_current_placements
    current_placements.count
  end

  def seats
    guaranteed_seats.to_i + movable_seats.to_i
  end

  def free_seats
    seats - number_of_current_placements
  end

  def total_placement_time
    placements.map(&:placement_time).inject(&:+)
  end

  def current_cost
    costs.each do |cost|
      return cost.amount if cost.end_date >= Date.today
    end
    nil
  end

  def current_cost?
    return true if cost_per_placement?

    costs.each do |cost|
      return true if cost.end_date >= Date.today
    end
    false
  end

  private

  def overlapping_cost(cost1, cost2)
    return if cost1 == cost2

    (cost1.start_date..cost1.end_date).overlaps?(cost2.start_date..cost2.end_date)
  end
end
