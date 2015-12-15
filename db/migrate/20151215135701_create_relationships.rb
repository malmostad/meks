class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :refugee_id
      t.integer :related_id

      t.timestamps null: false
    end
  end
end
