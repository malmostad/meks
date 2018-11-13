# 'Utflyttningsorsaker'
class MovedOutReason < ApplicationRecord
  has_many :placements, dependent: :nullify

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 191
end
