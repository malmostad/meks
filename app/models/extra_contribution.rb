# "Extra insatser"
class ExtraContribution < ApplicationRecord
  belongs_to :refugee, touch: true
  belongs_to :extra_contribution_type

  validates_presence_of :period_start, :period_end,
                        :extra_contribution_type_id, :refugee,
                        :fee, :expense, :contactor_employee_number,
                        :contractor_name, :contractor_birthday
  validates :fee, :expense, :contactor_employee_number, numericality: true
end
