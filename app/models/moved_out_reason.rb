class MovedOutReason < ActiveRecord::Base
  has_many :placements

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 191
end
