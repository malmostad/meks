class CreateTypeOfHousings < ActiveRecord::Migration
  def change
    create_table :type_of_housings do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :type_of_housings, :name, unique: true
  end
end
