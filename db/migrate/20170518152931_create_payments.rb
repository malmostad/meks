class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.references :refugee, index: true, foreign_key: true
      t.string :diarie
      t.date :period_start
      t.date :period_end
      t.float :amount
      t.references :payment_import, index: true, foreign_key: true

      t.timestamps
    end
  end
end
