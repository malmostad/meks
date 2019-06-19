# 'Ensambkommande barn'
class Refugee < ApplicationRecord
  include RefugeeIndex
  include RefugeeSearch

  belongs_to :gender
  belongs_to :municipality
  belongs_to :deregistered_reason

  has_many :placements, dependent: :destroy
  has_many :payments

  has_many :extra_contributions, dependent: :destroy
  accepts_nested_attributes_for :extra_contributions, reject_if: proc { |attr|
    attr[:extra_contribution_type].blank?
  }

  has_many :refugee_extra_costs, dependent: :destroy
  accepts_nested_attributes_for :refugee_extra_costs, reject_if: proc { |attr|
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

  validates :dossier_number, uniqueness: true, allow_blank: true, format: { with: /\A\d+\z/, message: "endast siffror" }

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
    Economy::PlacementAndHomeCost.new(placements).sum +
      Economy::FamilyAndEmergencyHomeCost.new(placements).sum
  end

  def total_costs
    total_placement_and_home_costs +
      Economy::PlacementExtraCost.new(placements).sum +
      Economy::ExtraContributionCost.new(self).sum +
      Economy::RefugeeExtraCost.new(self).sum
  end

  def total_rate
    (Economy::RatesForRefugee.new(self).sum || 0) + (Economy::OneTimePayment.new(self).sum || 0)
  end

  # Return a refugees placements within a give range
  # Example:
  #   refugees.first.placements_within('2017-05-01', '2017-07-01').first.home.name
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

  # Returns the asylum event for the refugee with latest date
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
    # FIXME: sort and max yields different results when there are multiple latest dates that are the same
    # dates.max_by { |_k, v| v }
    dates.sort_by { |_k, v| v }.last
  end

  def self.per_type_of_housing(type_of_housing, registered = DEFAULT_INTERVAL)
    includes(:payments, placements: { home: [:type_of_housings, :costs] })
      .where(placements: { home: { type_of_housings: { id: type_of_housing.id } } })
      .where(registered: registered[:from]..registered[:to])
  end
end
