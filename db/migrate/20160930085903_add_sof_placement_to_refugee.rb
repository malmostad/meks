class AddSofPlacementToRefugee < ActiveRecord::Migration[4.2]
  def change
    add_column :refugees, :sof_placement, :boolean, default: false
  end
end
