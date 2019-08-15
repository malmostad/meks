# 'Extra kostnad (knuten till personen)'
class PersonExtraCost < ApplicationRecord
  belongs_to :person, touch: true

  validates_presence_of :date, :amount
  validates :amount, numericality: true, allow_blank: true
  validates_length_of :comment, maximum: 191
end
