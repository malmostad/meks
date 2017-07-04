class AddCostToPlacement < ActiveRecord::Migration[5.0]
  def change
    add_column :placements, :cost, :integer
  end
end
