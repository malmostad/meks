# 'Personer'
class Person < ApplicationRecord
  include PersonIndex
  include PersonSearch

  belongs_to :gender
  belongs_to :municipality
  belongs_to :deregistered_reason

  has_many :placements, dependent: :destroy
  has_many :payments

  has_many :extra_contributions, dependent: :destroy
  accepts_nested_attributes_for :extra_contributions, reject_if: proc { |attr|
    attr[:extra_contribution_type].blank?
  }

  has_many :person_extra_costs, dependent: :destroy
  accepts_nested_attributes_for :person_extra_costs, reject_if: proc { |attr|
    attr[:date].blank?
  }

  has_many :current_placements, -> { where(moved_out_at: nil).where.not(moved_in_at: nil) },
    class_name: 'Placement'

  scope :with_current_placement, -> {
    includes(:placements)
      .where(placements: { moved_out_at: nil })
      .where.not(placements: { moved_in_at: nil })
      .order('placements.moved_in_at desc')
  }

  scope :in_our_municipality, -> {
    includes(:municipality)
      .where(municipalities: { our_municipality: true })
  }

  has_many :homes, through: :placements
  accepts_nested_attributes_for :placements,
    reject_if: proc { |attr| attr[:home_id].blank? }

  has_and_belongs_to_many :countries
  has_and_belongs_to_many :languages

  # Person has date_of_birth and ssn_extension attributes, `ssns` are additional ones
  has_many :ssns, dependent: :destroy
  accepts_nested_attributes_for :ssns,
    allow_destroy: true,
    reject_if: proc { |attr| attr[:date_of_birth].blank? }
  validates_associated :ssns

  # Person has a `dossier_number` attribute, `dossier_numbers` are additional ones
  has_many :dossier_numbers, dependent: :destroy
  accepts_nested_attributes_for :dossier_numbers,
    allow_destroy: true,
    reject_if: proc { |attr| attr[:name].blank? }
  validates_associated :dossier_numbers

  has_many :relationships, dependent: :destroy
  has_many :relateds, through: :relationships
  has_many :inverse_relationships, class_name: 'Relationship', foreign_key: 'related_id', dependent: :destroy
  has_many :inverse_relateds, through: :inverse_relationships, source: :person

  validates :dossier_number, uniqueness: true, allow_blank: true, format: { with: /\A\d+\z/, message: 'endast siffror' }

  validates_presence_of :name
  validates_length_of :name, maximum: 191

  validate :validate_date_of_birth

  before_save :clear_ekb_fields

  # Clear fields not releated to non-EKBs unless ekb is true
  def clear_ekb_fields
    return if ekb?

    ssns.destroy_all
    self.dossier_number = nil
    dossier_numbers.destroy_all
    self.special_needs = nil
    self.residence_permit_at = nil
    self.checked_out_to_our_city = nil
    self.temporary_permit_starts_at = nil
    self.temporary_permit_ends_at = nil
    self.citizenship_at = nil
    self.transferred = nil
    self.municipality_placement_migrationsverket_at = nil
    self.municipality_placement_comment = nil
    self.deregistered_reason = nil
  end

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

  def will_turn_21_in_year(year)
    return if date_of_birth.nil?

    date_at_21st_birthday >= Date.new(year) && date_at_21st_birthday <= Date.new(year).end_of_year
  end

  def date_at_21st_birthday
    return if date_of_birth.nil?

    date_of_birth + 21.years
  end

  def total_placement_time
    placements.map(&:placement_time).inject(&:+) || 0
  end

  def total_placement_and_home_costs
    Economy::PlacementAndHomeCost.new(placements, default_interval).sum +
      Economy::FamilyAndEmergencyHomeCost.new(placements, default_interval).sum
  end

  def total_costs
    total_placement_and_home_costs +
      Economy::PlacementExtraCost.new(placements, default_interval).sum +
      Economy::ExtraContributionCost.new(self, default_interval).sum +
      Economy::PersonExtraCost.new(self, default_interval).sum
  end

  def total_rate
    (Economy::RatesForPerson.new(self, default_interval).sum || 0) +
      (Economy::OneTimePayment.new(self, default_interval).sum || 0)
  end

  # Return a people placements within a give range
  # Example:
  #   people.first.placements_within('2017-05-01', '2017-07-01').first.home.name
  def placements_within(from, to)
    placements.map do |placement|
      from = from.to_date
      to = to.to_date

      # Default values assigned if nil
      moved_in_at = placement.moved_in_at || from
      moved_out_at = placement.moved_out_at || to

      next placement if (moved_in_at..moved_out_at).overlaps?((from - 1)..to)
    end.compact
  end

  def in_our_municipality?
    municipality&.our_municipality?
  end

  # Returns the asylum event for the person with latest date
  def asylum
    dates = %i[
      registered
      municipality_placement_migrationsverket_at
      residence_permit_at
      checked_out_to_our_city
      temporary_permit_starts_at
      temporary_permit_ends_at
      deregistered
    ]

    # Create a key/value hash from the array
    Hash[dates.map! { |k| [k.to_s, send(k)] }]

    dates = dates.delete_if { |_k, v| v.blank? }

    # Get the event with the latest date
    dates.sort_by { |_k, v| v }.last
  end

  def self.per_type_of_housing(type_of_housing)
    includes(:payments, placements: { home: [:type_of_housings, :costs] })
      .where(placements: { home: { type_of_housings: { id: type_of_housing.id } } })
      .where(registered: default_interval[:from]..default_interval[:to])
  end

  private

  def default_interval
    { from: Date.new(0), to: Date.today }
  end
end
