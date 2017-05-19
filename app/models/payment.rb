class Payment < ApplicationRecord
  belongs_to :refugee
  belongs_to :payment_import

  validates_presence_of :refugee_id, :period_start, :period_end, :amount
end
