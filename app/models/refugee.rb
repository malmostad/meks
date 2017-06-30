class Refugee < ApplicationRecord
  include RefugeeIndex
  include RefugeeSearch
  include RefugeeCosts
  include RefugeeRates
  include RefugeePayments

  belongs_to :gender
  belongs_to :municipality
  belongs_to :deregistered_reason

  has_many :placements, dependent: :destroy
  has_many :payments

  has_many :current_placements, -> { where(moved_out_at: nil).where.not(moved_in_at: nil) },
    class_name: 'Placement'

  scope :with_current_placement, -> {
    includes(:placements)
    .where(placements: { moved_out_at: nil })
    .where.not(placements: { moved_in_at: nil })
    .order('placements.moved_in_at desc')
  }

  has_many :homes, through: :placements
  accepts_nested_attributes_for :placements,
    reject_if: proc { |attr| puts attr.inspect; attr[:home_id].blank? }

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

  def ssn
    date_of_birth.to_s.delete('-') + '-' + ssn_extension.to_s if date_of_birth.present?
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

  # Get the asylum event with latest date
  def asylum_status
    dates = [:registered,
        :municipality_placement_migrationsverket_at,
        :municipality_placement_per_agreement_at,
        :residence_permit_at,
        :checked_out_to_our_city,
        :temporary_permit_starts_at,
        :temporary_permit_ends_at,
        :deregistered]

    # Create a key/value hash from the array
    Hash[dates.map! { |k| [k.to_s, send(k)] }]

    # Delete blanks
    dates = dates.delete_if { |_k, v| v.blank? }

    # Get the event with the latest date
    dates.sort_by { |_k, v| v }.last
  end

  # Comment in Swedish are from project specifications
  # Ankomstbarn typ 1:
  # - ska ha inskrivningsdatum
  # - ska inte ha anvisningskommun
  # - ska inte ha anvisningsdatum
  # - ska inte ha status avslutat
  # - ska inte datum för PUT
  # - ska inte datum för TUT
  # - ska inte datum för medborgarskap
  # - ska inte ha SoF-placering
  #
  # Ankomstbarn typ 2:
  # - ska ha inskrivningsdatum
  # - ska ha anvisningskommun
  # - ska ha anvisningsdatum där anvisningsdatumet ligger i framtiden
  # - ska inte ha status avslutat
  def self.in_arrival
    type1 = Refugee
            .where.not(registered: nil)
            .where(deregistered: nil)
            .where(municipality: nil)
            .where(municipality_placement_migrationsverket_at: nil)
            .where(residence_permit_at: nil)
            .where(temporary_permit_starts_at: nil)
            .where(citizenship_at: nil)
            .where(sof_placement: false)

    type2 = Refugee
            .where.not(registered: nil)
            .where.not(municipality: nil)
            .where('municipality_placement_migrationsverket_at > ?', Date.today)
            .where(deregistered: nil)

    (type1 + type2).uniq
  end
end
