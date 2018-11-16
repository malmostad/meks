# 'Extra kostnad (knuten till barn)'
class RefugeeExtraCost < ApplicationRecord
  default_scope { order(:date) }

  belongs_to :refugee, touch: true

  validates_presence_of :date, :amount
  validates :amount, numericality: true, allow_blank: true
  validates_length_of :comment, maximum: 191
end
