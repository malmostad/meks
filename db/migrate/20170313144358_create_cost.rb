class CreateCost < ActiveRecord::Migration[5.0]
  def change
    create_table :costs do |t|
      t.integer :amount
      t.date :start_date
      t.date :end_date
      t.references :home, index: true, foreign_key: true

      t.timestamps
    end
  end
end
