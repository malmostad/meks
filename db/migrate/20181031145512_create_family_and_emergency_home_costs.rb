class CreateFamilyAndEmergencyHomeCosts < ActiveRecord::Migration[5.2]
  def change
    create_table :family_and_emergency_home_costs do |t|
      t.references :placement, index: true, foreign_key: true, type: :integer
      t.date :period_start
      t.date :period_end
      t.decimal :fee, precision: 10, scale: 2
      t.decimal :expense, precision: 10, scale: 2

      t.timestamps
    end
  end
end
