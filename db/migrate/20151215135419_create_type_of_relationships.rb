class CreateTypeOfRelationships < ActiveRecord::Migration[4.2]
  def change
    create_table :type_of_relationships do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :type_of_relationships, :name, unique: true
  end
end
