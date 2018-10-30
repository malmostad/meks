class CreateRefugeeExtraCost < ActiveRecord::Migration[5.2]
  def change
    create_table :refugee_extra_costs do |t|
      t.references :refugee, index: true, foreign_key: true, type: :integer
      t.date :date
      t.decimal :amount, precision: 10, scale: 2
      t.string :comment

      t.timestamps
    end
  end
end
