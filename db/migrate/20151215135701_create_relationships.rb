class CreateRelationships < ActiveRecord::Migration[4.2]
  def change
    create_table :relationships do |t|
      t.integer :refugee_id
      t.integer :related_id
      t.references :type_of_relationship, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :relationships, :refugee_id
    add_index :relationships, :related_id
    add_index :relationships, [:refugee_id, :related_id], unique: true
  end
end
