class CreateDailyFees < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_fees do |t|
      t.integer :fee
      t.date :start_date
      t.references :home, index: true, foreign_key: true

      t.timestamps
    end
  end
end
