class CreateLegalCode < ActiveRecord::Migration[5.0]
  def change
    create_table :legal_codes do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :legal_codes, :name, unique: true

    add_reference :placements, :legal_code, index: true, foreign_key: true
  end
end
