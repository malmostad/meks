# 'Familje/jourhemskostnad'
class FamilyAndEmergencyHomeCost < ApplicationRecord
  belongs_to :placement, touch: true

  validates_presence_of :period_start, :period_end
  validates :fee, :expense, :pu_extra, numericality: true, allow_blank: true
end
