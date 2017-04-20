class Refugee < ApplicationRecord
  include RefugeeIndex
  include RefugeeSearch
  # include Economy

  # TODO: implement
  attr_reader :expected_cost, :expected_rate, :paid_amount

  belongs_to :gender
  belongs_to :municipality
  belongs_to :deregistered_reason

  has_many :placements, dependent: :destroy

  has_many :current_placements, -> { where(moved_out_at: nil).where.not(moved_in_at: nil) },
    class_name: 'Placement'

  scope :with_current_placement, -> {
    includes(:placements)
    .where(placements: { moved_out_at: nil })
    .where.not(placements: { moved_in_at: nil })
    .order('placements.moved_in_at desc')
  }

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

    # Create a k: v hash from the array
    Hash[dates.map! { |k| [k.to_s, send(k)] }]

    # Delete blanks
    dates = dates.delete_if { |_k, v| v.blank? }

    # Get the event with the latest date
    dates.sort_by { |_k, v| v }.last
  end

  # TODO: implement
  def home_costs(placements_from = '2016-01-01', placements_to = '2017-04-01')
    formulas = placements.includes(home: :costs).map do |placement|
      logger.debug ''
      logger.debug "placement.home.name: #{placement.home.name}"
      moved_out_at = placement.moved_out_at || Date.today
      moved_in_at  = placement.moved_in_at

      # Count days from the latest start date and the earliest end date
      #   by comparing the placements range and the range for the report
      count_from = [moved_in_at, placements_from.to_date].max_by(&:to_date)
      count_to   = [moved_out_at, placements_to.to_date].min_by(&:to_date)

      # logger.debug "moved_in_at: #{moved_in_at}, placements_from.to_date: #{placements_from.to_date}, count_from: #{count_from}"
      # logger.debug "moved_out_at: #{moved_out_at}, placements_to.to_date: #{placements_to.to_date}, count_to #{count_to}"

      # TODO: use the home cost that falls into the range. Not the first cost!
      # Use 0 if no amount is added to the home within the range
      placement.home.costs.map do |cost|
        starts_at = [count_from, cost.start_date].max_by(&:to_date)
        ends_at = [count_to, cost.end_date].min_by(&:to_date)

        days = (ends_at - starts_at).to_i

        logger.debug "starts_at: #{starts_at}"
        logger.debug "ends_at: #{ends_at}"
        logger.debug "cost.amount: #{cost.amount}"
        logger.debug "days: #{days}"
        next if days.zero? || days.negative?

        "(#{cost.amount}*#{days})"
      end
    end

    formulas.flatten!.reject!(&:nil?)

    "=#{formulas.flatten.join('+')}"
  end

  # TODO: implement
  def expected_rate
    '=31*1350'
  end

  # TODO: implement
  def paid_amount
    '=31*1350'
  end
end
