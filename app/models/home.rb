class Home < ActiveRecord::Base
  has_and_belongs_to_many :refugees
  has_and_belongs_to_many :type_of_housings
  has_and_belongs_to_many :owner_types
  has_and_belongs_to_many :target_groups
  has_and_belongs_to_many :languages

  default_scope { order('name') }

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 255
end
