class AddCommentToPlacementExtraCost < ActiveRecord::Migration[5.2]
  def change
    add_column :placement_extra_costs, :comment, :string
  end
end
