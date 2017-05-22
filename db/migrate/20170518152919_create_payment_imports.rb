class CreatePaymentImports < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_imports do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :imported_at
      t.text :warnings
      t.string :content_type
      t.string :original_filename
      t.binary :raw, limit: 15.megabyte
      t.text :raw, limit: 1.megabyte
      t.timestamps
    end
  end
end
