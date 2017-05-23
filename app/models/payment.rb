class Payment < ApplicationRecord
  attr_accessor :amount_as_string

  belongs_to :refugee
  belongs_to :payment_import

  validates_presence_of :refugee_id, :period_start, :period_end
  validates :amount, presence: true, numericality: true

  before_validation do
    # Convert Swedish float format to US
    self.amount = amount_as_string.tr(',', '.').to_f
  end
end
