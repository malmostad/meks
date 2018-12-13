class RemovePuExtraToFamilyAndEmergencyHomeCost < ActiveRecord::Migration[5.2]
  def up
    remove_column :family_and_emergency_home_costs, :pu_extra
  end

  def down
    add_column :family_and_emergency_home_costs, :pu_extra, :decimal, precision: 12, scale: 2
  end
end
