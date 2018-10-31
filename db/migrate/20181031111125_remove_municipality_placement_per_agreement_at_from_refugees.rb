class RemoveMunicipalityPlacementPerAgreementAtFromRefugees < ActiveRecord::Migration[5.2]
  def up
    remove_column :refugees, :municipality_placement_per_agreement_at
  end

  def down
    add_column :refugees, :municipality_placement_per_agreement_at, :date
  end
end
