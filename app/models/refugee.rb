class Refugee < ActiveRecord::Base

  include RefugeeSearch

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
    reject_if: proc { |attr| attr[:date_of_birth].blank? }
  validates_associated :ssns

  has_many :dossier_numbers, dependent: :destroy
  accepts_nested_attributes_for :dossier_numbers,
    allow_destroy: true,
    reject_if: proc { |attr| attr[:name].blank? }
  validates_associated :dossier_numbers

  has_many :relationships, dependent: :destroy
  has_many :relateds, through: :relationships, dependent: :destroy
  has_many :inverse_relationships, class_name: 'Relationship', foreign_key: 'related_id', dependent: :destroy
  has_many :inverse_relateds, through: :inverse_relationships, source: :refugee

  validates_presence_of :name
  validates_length_of :name, maximum: 191

  # The SSN that is most reacently updated is the primary one
  def primary_ssn
    ssns.sort_by{|k| k.updated_at}.reverse.first
  end

  # The dossier number that is most reacently updated is the primary one
  def primary_dossier_number
    return '' if dossier_numbers.blank?
    dossier_numbers.sort_by{|k| k.updated_at}.reverse.first.name
  end

  # Age old in years
  def age
    return if primary_ssn.blank?

    dob = primary_ssn.date_of_birth
    years_old = Date.today.year - dob.year
    years_old -= 1 if Date.today < dob + years_old.years
    years_old
  end

  def total_placement_time
    placements.map(&:placement_time).inject(&:+) || 0
  end
end
