class CreateRefugees < ActiveRecord::Migration[4.2]
  def change
    create_table :refugees do |t|
      t.boolean :draft, default: false
      t.string :name
      t.date :date_of_birth
      t.integer :ssn_extension
      t.string :dossier_number
      t.date :registered
      t.date :deregistered
      t.date :residence_permit_at
      t.date :checked_out_to_our_city
      t.date :temporary_permit_starts_at
      t.date :temporary_permit_ends_at
      t.references :municipality, index: true, foreign_key: true
      t.date :municipality_placement_migrationsverket_at
      t.date :municipality_placement_per_agreement_at
      t.text :municipality_placement_comment
      t.text :deregistered_reason
      t.boolean :special_needs
      t.text :other_relateds
      t.text :comment
      t.references :gender, index: true, foreign_key: true

      t.timestamps null: false
    end

    create_table :countries_refugees, id: false do |t|
      t.belongs_to :country, index: true
      t.belongs_to :refugee, index: true

      t.timestamps null: false
    end

    create_table :languages_refugees, id: false do |t|
      t.belongs_to :language, index: true
      t.belongs_to :refugee, index: true

      t.timestamps null: false
    end

    create_table :ssns do |t|
      t.date :date_of_birth
      t.integer :extension
      t.references :refugee, index: true

      t.timestamps null: false
    end

    create_table :dossier_numbers do |t|
      t.string :name
      t.references :refugee, index: true

      t.timestamps null: false
    end
    add_index :dossier_numbers, :name, unique: true
  end
end
