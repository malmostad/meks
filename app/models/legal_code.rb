class LegalCode < ApplicationRecord
  has_many :placements, dependent: :nullify
  has_many :rate_categories, dependent: :nullify

  default_scope { order(:name) }

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 191
end
