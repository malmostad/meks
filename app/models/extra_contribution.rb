# "Extra insatser"
class ExtraContribution < ApplicationRecord
  belongs_to :refugee
  belongs_to :extra_contribution_type

  validates_presence_of :period_start, :period_end,
                        :extra_contribution_type_id, :refugee
  validates :fee, :expense, presence: false, numericality: true
end
