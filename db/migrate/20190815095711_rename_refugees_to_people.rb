class RenameRefugeesToPeople < ActiveRecord::Migration[5.2]
  def change
    rename_column :countries_refugees, :refugee_id, :person_id
    rename_column :dossier_numbers, :refugee_id, :person_id
    rename_column :extra_contributions, :refugee_id, :person_id
    rename_column :languages_refugees, :refugee_id, :person_id
    rename_column :payments, :refugee_id, :person_id
    rename_column :placements, :refugee_id, :person_id
    rename_column :refugee_extra_costs, :refugee_id, :person_id
    rename_column :relationships, :refugee_id, :person_id
    rename_column :ssns, :refugee_id, :person_id

    rename_table :refugees, :people
    rename_table :countries_refugees, :countries_people
    rename_table :languages_refugees, :languages_people
    rename_table :refugee_extra_costs, :person_extra_costs
  end
end
