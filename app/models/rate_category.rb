# A.k.a. 'Schablon'
class RateCategory < ApplicationRecord
  # meth is used for sending a method , *_age are used as arguments
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
