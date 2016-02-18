class RemoveCommentFromPlacements < ActiveRecord::Migration
  def change
    remove_column :refugees, :comment
  end
end
