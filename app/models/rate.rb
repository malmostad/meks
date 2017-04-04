# Amount for RateCategory (Schablon)
class Rate < ApplicationRecord
  belongs_to :rate_category

  default_scope { order(:start_date) }

  validates :rate_category, presence: true
  validates :amount, presence: true, numericality: true
  validate :date_format, :date_range, :no_overlaps

  def date_format
    unless start_date.is_a?(Date) && end_date.is_a?(Date)
      return errors.add(:amount, 'Ogiltigt datumformat, ska vara yyyy-mm-dd')
    end
  end

  def date_range
    if start_date >= end_date
      errors.add(:amount, 'Startdatum måste infalla innan slutdatum')
    end
  end

  # A rate period must not overlap with another
  def no_overlaps
    if siblings.where("? <= end_date AND ? >= start_date", start_date, end_date).present?
      errors.add(:amount, 'Intervallet överlappar med ett annat')
    end
  end

  def siblings
    rate_category.rates.where.not(id: id)
  end
end
