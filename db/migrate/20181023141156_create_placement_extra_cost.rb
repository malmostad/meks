class CreatePlacementExtraCost < ActiveRecord::Migration[5.2]
  def change
    create_table :placement_extra_costs do |t|
      t.references :placement, index: true, foreign_key: true, type: :integer
      t.date :date
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
