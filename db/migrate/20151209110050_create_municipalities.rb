class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :municipalities, :name, unique: true
  end
end
