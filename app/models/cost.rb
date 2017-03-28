# Cost for homes
class Cost < ApplicationRecord
  attr_accessor :total_cost

  belongs_to :home

  default_scope { order(:start_date) }

  validates :home, presence: true
  validates :amount, presence: true, numericality: true
  validate :validate_dates

  def validate_dates
    unless start_date.is_a?(Date) && end_date.is_a?(Date)
      return errors.add(:amount, 'Ogiltigt datumformat, ska vara yyyy-mm-dd')
    end

    if start_date >= end_date
      errors.add(:amount, 'Startdatum måste infalla innan slutdataum')
    end
  end
end
