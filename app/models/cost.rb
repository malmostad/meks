# Cost for homes
class Cost < ApplicationRecord
  attr_accessor :total_cost

  belongs_to :home

  default_scope { order(:start_date) }

  validates :home, presence: true
  validates :amount, presence: true, numericality: true
  validate do
     date_format(:amount)
     date_range(:amount)
     no_overlaps(:amount)
  end

  def siblings
    home.costs.where.not(id: id)
  end
end
