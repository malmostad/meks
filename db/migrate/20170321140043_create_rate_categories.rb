class CreateRateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :rate_categories do |t|
      t.string :name
      t.integer :from_age
      t.integer :to_age
      t.text :description

      t.timestamps
    end
    add_index :rate_categories, :name, unique: true
  end
end
