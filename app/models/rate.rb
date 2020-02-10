# 'Schablonbelopp'
# Amount for RateCategory
class Rate < ApplicationRecord
  belongs_to :rate_category, touch: true

  default_scope { order(:start_date) }

  validates :rate_category, :start_date, :end_date, presence: true
  validates :amount, presence: true, numericality: true
  validate do
    date_format(:amount)
    date_range(:amount, start_date, end_date)
  end
end
