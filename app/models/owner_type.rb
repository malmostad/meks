class OwnerType < ActiveRecord::Base
  has_and_belongs_to_many :homes

  default_scope { order('name') }

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 255
end
