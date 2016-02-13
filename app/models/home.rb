class Home < ActiveRecord::Base

  has_many :placements, dependent: :destroy
  has_many :refugees, through: :placements

  has_and_belongs_to_many :type_of_housings
  has_and_belongs_to_many :target_groups
  has_and_belongs_to_many :languages
  belongs_to :owner_type

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 191

  default_scope { order(:name) }

  def current_placements
    placements.where(moved_out_at: nil)
  end

  def number_of_current_placements
    current_placements.count

    # Pure Ruby to prevent n+1 in certain cases
    # placements.reject { |p| p.moved_out_at.present? }.size
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
end
