# Amount for RateCategory (Schablon)
class Rate < ApplicationRecord
  belongs_to :rate_category

  default_scope { order(:start_date) }

  validates :rate_category, presence: true
  validates :amount, presence: true, numericality: true
  validate :valid_dates, :no_overlaps

  def valid_dates
    unless start_date.is_a?(Date) && end_date.is_a?(Date)
      return errors.add(:amount, 'Ogiltigt datumformat, ska vara yyyy-mm-dd')
    end

    if start_date >= end_date
      errors.add(:amount, 'Startdatum måste infalla innan slutdatum')
    end
  end

  # Check that the date range doesn't overlap with another rate
  def no_overlaps
    if siblings.where("? <= end_date AND ? >= start_date", start_date, end_date).present?
      errors.add(:amount, 'Intervallet överlappar med ett annat')
    end
  end

  def siblings
    rate_category.rates.where.not(id: id)
  end
end
