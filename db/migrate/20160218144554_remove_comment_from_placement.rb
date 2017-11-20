class RemoveCommentFromPlacement < ActiveRecord::Migration[4.2]
  def change
    remove_column :placements, :comment
  end
end
