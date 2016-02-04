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
    placements.all
  end

  def seats
    guaranteed_seats.to_i + movable_seats.to_i
  end

  def free_seats
    seats - current_placements.size
  end

  def total_placement_time
    placements.map(&:placement_time).inject(&:+)
  end
end
