# 'Familje/jourhemskostnad'
class FamilyAndEmergencyHomeCost < ApplicationRecord
  belongs_to :placement, touch: true

  validates_presence_of :period_start, :period_end, :fee,
                        :contractor_name, :contractor_birthday, :contactor_employee_number
  validates :fee, :contactor_employee_number, numericality: true
  validates :expense, numericality: true, allow_blank: true
end
