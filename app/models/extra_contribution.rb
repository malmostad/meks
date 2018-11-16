# "Extra insatser"
class ExtraContribution < ApplicationRecord
  default_scope { order(:period_start) }

  belongs_to :refugee, touch: true
  belongs_to :extra_contribution_type

  validates_presence_of :period_start, :period_end,
                        :extra_contribution_type_id, :refugee
  validates :fee, :expense, numericality: true, allow_blank: true
end
