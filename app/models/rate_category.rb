# 'Schablongrupp'
class RateCategory < ApplicationRecord
  # `enum` maps qualifier number in DB to the qualifiers below
  # `meth` is used for sending qualifiers to a method to select people
  # `min_age` and `max_age` are used as arguments
  #
  # Run:
  # rake db:seed_rate_categories
  # to create the rate categories with dummy rates
  enum qualifier: [
    { meth: :arrival_0_17,     min_age: 0,  max_age: 17 },
    { meth: :assigned_0_17,    min_age: 0,  max_age: 17 },
    { meth: :temporary_permit, min_age: 0,  max_age: 17 },
    { meth: :temporary_permit, min_age: 18, max_age: 20 },
    { meth: :residence_permit, min_age: 0,  max_age: 17 },
    { meth: :residence_permit, min_age: 18, max_age: 20 }
  ]

  has_many :rates, dependent: :destroy
  accepts_nested_attributes_for :rates, allow_destroy: true
  validates_associated :rates

  validates :name, :human_name, presence: true

  after_save do
    # Rollback transaction if cost date ranges overlaps
    validate_associated_date_overlaps(rates, :amount)
  end

  after_commit do
    Rails.cache.delete('RateCategory/all')
  end

  def self.all_cached
    Rails.cache.fetch('RateCategory/all') { all.includes(:rates).load }
  end

  def age_range
    if from_age && to_age && from_age >= to_age
      errors.add(:from_age, '"Från och med ålder" måste infalla före "till-ålder"')
    end
  end

  def current_rate?
    rates.each do |rate|
      return true if rate.end_date >= Date.today && rate.amount&.positive?
    end
    false
  end
end
