# a.k.a. 'Schablon'
class RateCategory < ApplicationRecord
  has_many :rates, dependent: :destroy
  accepts_nested_attributes_for :rates, allow_destroy: true
  validates_associated :rates

  validates :name, :human_name, :description, presence: true

  after_save do
    # Rollback transaction if cost date ranges overlaps
    validate_associated_date_overlaps(rates, :amount)
  end

  def age_range
    if from_age && to_age && from_age >= to_age
      errors.add(:from_age, '"Från och med ålder" måste infalla före "till-ålder"')
    end
  end

  def current_rate?
    rates.each do |rate|
      return true if rate.end_date >= Date.today
    end
    false
  end
end
