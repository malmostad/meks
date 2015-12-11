class Refugee < ActiveRecord::Base
  belongs_to :gender

  has_and_belongs_to_many :homes
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :languages

  has_many :ssns, dependent: :destroy
  accepts_nested_attributes_for :ssns,
    allow_destroy: true,
    reject_if: proc { |attr| attr[:name].blank? }
  validates_associated :ssns

  has_many :dossier_numbers, dependent: :destroy
  accepts_nested_attributes_for :dossier_numbers,
    allow_destroy: true,
    reject_if: proc { |attr| attr[:name].blank? }
  validates_associated :dossier_numbers

  validates_presence_of :name
  validates_length_of :name, maximum: 255
end
