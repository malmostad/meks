class CreateOwnerTypes < ActiveRecord::Migration
  def change
    create_table :owner_types do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :owner_types, :name, unique: true
  end
end
