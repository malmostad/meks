class Home < ActiveRecord::Base

  has_many :placements
  has_many :refugees, through: :placements

  has_and_belongs_to_many :type_of_housings
  has_and_belongs_to_many :target_groups
  has_and_belongs_to_many :languages
  belongs_to :owner_type

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 191

  def current_placements
    placements.includes(:refugee,
      refugee: [:languages, :countries, :dossier_numbers, :ssns, :gender]
      ).where(moved_out_at: nil).order('refugees.name')
  end

  def seats
    guaranteed_seats + movable_seats
  end

  def total_placement_time
    placements.map(&:placement_time).inject(&:+)
  end
end
