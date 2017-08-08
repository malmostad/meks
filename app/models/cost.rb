# Cost for homes
class Cost < ApplicationRecord
  attr_accessor :total_cost

  belongs_to :home

  default_scope { order(:start_date) }

  validates :amount, presence: true, numericality: true
  validate do
    date_format(:amount)
    date_range(:amount, start_date, end_date)
  end
end