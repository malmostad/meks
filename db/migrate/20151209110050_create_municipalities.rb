class CreateMunicipalities < ActiveRecord::Migration[4.2]
  def change
    create_table :municipalities do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :municipalities, :name, unique: true
  end
end
