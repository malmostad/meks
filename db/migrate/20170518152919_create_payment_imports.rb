class CreatePaymentImports < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_imports do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :imported_at
      t.integer :number_of_records

      t.timestamps
    end
  end
end
