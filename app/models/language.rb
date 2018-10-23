# 'Språk'
class Language < ApplicationRecord
  has_and_belongs_to_many :homes
  has_and_belongs_to_many :refugees

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 191
end
