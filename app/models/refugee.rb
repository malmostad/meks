class Refugee < ActiveRecord::Base
  attr_reader :total_placement_time

  belongs_to :gender
  belongs_to :municipality

  has_many :placements
  has_many :homes, through: :placements
  accepts_nested_attributes_for :placements, reject_if: :all_blank

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
  validates_length_of :name, maximum: 191

  def total_placement_time
    placements.map(&:placement_time).inject(&:+)
  end
end
