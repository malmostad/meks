class CreateRates < ActiveRecord::Migration[5.0]
  def change
    create_table :rates do |t|
      t.integer :amount
      t.date :start_date
      t.date :end_date
      t.references :rate_category, index: true, foreign_key: true

      t.timestamps
    end
  end
end
