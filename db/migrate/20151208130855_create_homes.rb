class CreateHomes < ActiveRecord::Migration[4.2]
  def change
    create_table :homes do |t|
      t.string :name
      t.string :phone
      t.string :fax
      t.string :address
      t.string :post_code
      t.string :postal_town
      t.references :owner_type, index: true, foreign_key: true
      t.integer :guaranteed_seats
      t.integer :movable_seats
      t.boolean :active, default: true
      t.string :languages
      t.text :comment

      t.timestamps null: false
    end
    add_index :homes, :name, unique: true

    create_table :homes_type_of_housings, id: false do |t|
      t.belongs_to :home, index: true
      t.belongs_to :type_of_housing, index: true
    end

    create_table :homes_target_groups, id: false do |t|
      t.belongs_to :home, index: true
      t.belongs_to :target_group, index: true
    end

    create_table :homes_languages, id: false do |t|
      t.belongs_to :home, index: true
      t.belongs_to :language, index: true
    end

    create_table :countries_homes, id: false do |t|
      t.belongs_to :country, index: true
      t.belongs_to :home, index: true
    end
  end
end
