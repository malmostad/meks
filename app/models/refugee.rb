class Refugee < ActiveRecord::Base
  include RefugeeSearch

  belongs_to :gender
  belongs_to :municipality
  belongs_to :deregistered_reason

  has_many :placements, dependent: :destroy
  has_many :homes, through: :placements
  accepts_nested_attributes_for :placements, reject_if: :all_blank

  has_and_belongs_to_many :countries
  has_and_belongs_to_many :languages

  # Refugee has date_of_birth and ssn_extension attributes, `ssns` are additional ones
  has_many :ssns, dependent: :destroy
  accepts_nested_attributes_for :ssns,
    allow_destroy: true,
    reject_if: proc { |attr| attr[:date_of_birth].blank? }
  validates_associated :ssns

  # Refugee has a `dossier_number` attribute, `dossier_numbers` are additional ones
  has_many :dossier_numbers, dependent: :destroy
  accepts_nested_attributes_for :dossier_numbers,
    allow_destroy: true,
    reject_if: proc { |attr| attr[:name].blank? }
  validates_associated :dossier_numbers

  has_many :relationships, dependent: :destroy
  has_many :relateds, through: :relationships
  has_many :inverse_relationships, class_name: 'Relationship', foreign_key: 'related_id', dependent: :destroy
  has_many :inverse_relateds, through: :inverse_relationships, source: :refugee

  validates_uniqueness_of :dossier_number, case_sensitive: false, allow_blank: true

  validates_presence_of :name
  validates_length_of :name, maximum: 191

  validate :validate_date_of_birth

  def validate_date_of_birth
    return true if date_of_birth_before_type_cast.blank?
    unless date_of_birth_before_type_cast =~ /\A\d{4}-\d{2}-\d{2}\z/
      errors.add(:date_of_birth, 'Ogiltigt datumformat, måste vara yyyy-mm-dd')
    end
  end

  def current_placements
    placements.includes(:home).where(moved_out_at: nil)
  end

  def ssn
    date_of_birth.to_s.gsub('-', '') + '-' + ssn_extension.to_s
  end

  # Age old in years
  def age
    return if date_of_birth.nil?

    years_old = Date.today.year - date_of_birth.year
    years_old -= 1 if Date.today < date_of_birth + years_old.years
    years_old
  end

  def total_placement_time
    placements.map(&:placement_time).inject(&:+) || 0
  end
end
