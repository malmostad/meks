class AddContractorToExtraContributions < ActiveRecord::Migration[5.2]
  def change
    add_column :extra_contributions, :contractor_name, :string
    add_column :extra_contributions, :contractor_birthday, :date
    add_column :extra_contributions, :contactor_employee_number, :integer
  end
end
