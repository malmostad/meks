class OneTimePayment < ApplicationRecord
  default_scope { order(:start_date) }

  validates :amount, :start_date, :end_date, presence: true
  validate do
    date_range(:start_date, start_date, end_date)
  end
end
