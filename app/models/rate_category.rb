# a.k.a. 'Schablon'
class RateCategory < ApplicationRecord
  has_many :rates, dependent: :destroy
  accepts_nested_attributes_for :rates,
    allow_destroy: true
  validates_associated :rates

  belongs_to :legal_code

  default_scope { order(:name, :from_age) }

  validates :name, :legal_code, presence: true
  validates :from_age, :to_age, presence: true, numericality: true
  validate do
    date_range(:from_age, from_age, to_age)
  end

  after_save do
    # Rollback transaction if cost date ranges overlaps
    validate_associated_date_overlaps(rates, :amount)
  end

  def age_range
    if from_age && to_age && from_age >= to_age
      errors.add(:from_age, '"Från och med ålder" måste infalla före "till-ålder"')
    end
  end
end
