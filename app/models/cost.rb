# Cost for homes
# 'Dygnskostnad'
class Cost < ApplicationRecord
  belongs_to :home

  default_scope { order(:start_date) }

  validates :amount, presence: true, numericality: true
  validate do
    errors.add(:amount, 'Boendet har inte konstnadsformen Dygnskostnad') unless home.cost_per_day?

    date_format(:amount)
    date_range(:amount, start_date, end_date)
  end
end
