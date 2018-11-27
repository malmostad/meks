class RemoveOurMunicipalityDepartmentFromMunicipalities < ActiveRecord::Migration[5.2]
  def up
    remove_column :municipalities, :our_municipality_department
  end

  def down
    remove_column :municipalities, :our_municipality_department, :boolean
  end
end
