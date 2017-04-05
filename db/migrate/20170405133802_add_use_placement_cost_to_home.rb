class AddUsePlacementCostToHome < ActiveRecord::Migration[5.0]
  def change
    add_column :homes, :use_placement_cost, :boolean, default: false
  end
end
