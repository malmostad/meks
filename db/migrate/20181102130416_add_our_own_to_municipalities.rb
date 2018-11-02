class AddOurOwnToMunicipalities < ActiveRecord::Migration[5.2]
  def change
    add_column :municipalities, :our_municipality, :boolean
    add_column :municipalities, :our_municipality_department, :boolean
  end
end
