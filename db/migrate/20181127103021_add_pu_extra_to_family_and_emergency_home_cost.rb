class AddPuExtraToFamilyAndEmergencyHomeCost < ActiveRecord::Migration[5.2]
  def change
    add_column :family_and_emergency_home_costs, :pu_extra, :decimal, precision: 12, scale: 2
  end
end
