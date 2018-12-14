# 'Procentsatser för PO-pålägg'
class PoRate < ApplicationRecord
  default_scope { order(:start_date) }

  validates :rate_under_65, :rate_from_65, :start_date, :end_date, presence: true
  validates :rate_under_65, :rate_from_65, numericality: true
  validate do
    date_format(:rate_under_65)
    date_range(:rate_under_65, start_date, end_date)
  end
end
