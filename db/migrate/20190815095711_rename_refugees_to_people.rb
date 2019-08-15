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

    # rename_index :countries_refugees, :index_countries_refugees_on_refugee_id, :index_countries_people_on_person_id
    # rename_index :dossier_numbers, :index_dossier_numbers_on_refugee_id, :index_dossier_numbers_on_people_id
    # rename_index :extra_contributions, :index_extra_contributions_on_refugee_id, :index_extra_contributions_on_person_id
    # rename_index :languages_refugees, :index_languages_refugees_on_refugee_id, :index_languages_people_on_person_id
    # rename_index :payments, :index_payments_on_refugee_id, :index_payments_on_person_id
    # rename_index :placements, :index_placements_on_refugee_id, :index_placements_on_person_id
    # rename_index :refugee_extra_costs, :index_refugee_extra_costs_on_refugee_id, :index_person_extra_costs_on_person_id
    # rename_index :refugees, :index_refugees_on_deregistered_reason_id, :index_people_on_deregistered_reason_id
    # rename_index :refugees, :index_refugees_on_gender_id, :index_people_on_gender_id
    # rename_index :refugees, :index_refugees_on_municipality_id, :index_people_on_municipality_id
    # rename_index :relationships, :index_relationships_on_refugee_id_and_related_id, :index_relationships_on_person_id_and_related_id
    # rename_index :relationships, :index_relationships_on_refugee_id, :index_relationships_on_person_id
    # rename_index :ssns, :index_ssns_on_refugee_id, :index_ssns_on_person_id

    rename_table :refugees, :people
    rename_table :countries_refugees, :countries_people
    rename_table :languages_refugees, :languages_people
    rename_table :refugee_extra_costs, :person_extra_costs
  end
end
