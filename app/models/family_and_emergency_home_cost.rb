# 'Familje/jourhemskostnad'
class FamilyAndEmergencyHomeCost < ApplicationRecord
  belongs_to :placement, touch: true

  validates_presence_of :period_start, :period_end, :contractor_name,
                        :contractor_birthday, :fee, :expense, :contactor_employee_number
  validates :fee, :expense, :contactor_employee_number, numericality: true
end
