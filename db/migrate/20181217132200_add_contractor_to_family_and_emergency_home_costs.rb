class AddContractorToFamilyAndEmergencyHomeCosts < ActiveRecord::Migration[5.2]
  def change
    add_column :family_and_emergency_home_costs, :contractor_name, :string
    add_column :family_and_emergency_home_costs, :contractor_birthday, :date
    add_column :family_and_emergency_home_costs, :contactor_employee_number, :integer
  end
end
