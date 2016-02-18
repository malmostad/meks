class RemoveCommentFromPlacement < ActiveRecord::Migration
  def change
    remove_column :placements, :comment
  end
end
