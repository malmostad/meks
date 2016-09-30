class AddSofPlacementToRefugee < ActiveRecord::Migration
  def change
    add_column :refugees, :sof_placement, :boolean, default: false
  end
end
