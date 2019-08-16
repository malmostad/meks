# 'Utbetalning'
class Payment < ApplicationRecord
  attr_accessor :amount_as_string

  belongs_to :person
  belongs_to :payment_import

  validates_presence_of :person_id, :period_start, :period_end
  validates :amount, presence: true, numericality: true

  before_validation do
    # Convert Swedish format to US
    self.amount = amount_as_string.tr(',', '.').to_f if amount_as_string
  end

  def days
    (period_end - period_start).to_i + 1
  end

  def per_day
    amount / days
  end
end
