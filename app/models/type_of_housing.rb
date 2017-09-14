class TypeOfHousing < ApplicationRecord
  has_and_belongs_to_many :homes

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 191

  def placements_cost_per_home(range = DEFAULT_DATE_RANGE)
    homes.map do |home|
      Statistics::Costs.for_placements_and_home(home.placements, range)
    end
  end
end
