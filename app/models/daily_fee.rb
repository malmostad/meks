# Fee per day for homes. Different fees for different periods (typical a year)
class DailyFee < ApplicationRecord
  belongs_to :home

  default_scope { order(:start_date) }

  validates :home, :fee, :start_date, presence: true
  validates :fee, numericality: true
  validates :start_date, format: { with: /\A\d{4}\-\d{2}\-\d{2}\z/,
      message: "Ogiltigt datumformat, måste vara yyyy-mm-dd" }
end
