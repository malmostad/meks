# 'Procentsatser för PO-pålägg'
class PoRate < ApplicationRecord
  default_scope { order(:start_date) }

  validates :rate_under_65, :rate_from_65, :start_date, :end_date, presence: true
  validates :rate_under_65, :rate_from_65, numericality: true
  validate do
    date_range(:start_date, start_date, end_date)
  end
end
