# Fee per day for homes. Different fees for different periods.
class DailyFee < ApplicationRecord
  attr_accessor :total_fee

  belongs_to :home

  default_scope { order(:start_date) }

  validates :home, presence: true
  validates :fee, presence: true, numericality: true
  validate :validate_dates

  def validate_dates
    unless start_date.is_a?(Date) && end_date.is_a?(Date)
      return errors.add(:fee, 'Ogiltigt datumformat, ska vara yyyy-mm-dd')
    end

    if start_date >= end_date
      errors.add(:fee, 'Startdatum måste infalla innan slutdataum')
    end
  end
end
