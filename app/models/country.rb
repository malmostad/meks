class Country < ActiveRecord::Base
  has_and_belongs_to_many :refugees
  has_many :citizenships,
           class_name: 'Refugee',
           foreign_key: :citizenship_id, dependent: :nullify

  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :name
  validates_length_of :name, maximum: 191
end
