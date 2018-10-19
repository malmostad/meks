class Home < ApplicationRecord
  enum type_of_cost: %i[
    per_day
    per_placement
    for_family_and_emergency_home
  ]

  has_many :placements, dependent: :destroy
  has_many :refugees, through: :placements

  has_many :costs, dependent: :destroy
  accepts_nested_attributes_for :costs, allow_destroy: true
  validates_associated :costs

  has_and_belongs_to_many :type_of_housings
  has_and_belongs_to_many :target_groups
  has_and_belongs_to_many :languages
  belongs_to :owner_type

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 191

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
    return true if use_placement_cost?
    costs.each do |cost|
      return true if cost.end_date >= Date.today
    end
    false
  end

  def payments(range = DEFAULT_DATE_RANGE)
    refugees_payments = refugees.map(&:payments).flatten.compact
    Economy::Payment.amount_and_days(refugees_payments, range)
  end

  private

  def overlapping_cost(cost1, cost2)
    return if cost1 == cost2

    (cost1.start_date..cost1.end_date).overlaps?(cost2.start_date..cost2.end_date)
  end
end
