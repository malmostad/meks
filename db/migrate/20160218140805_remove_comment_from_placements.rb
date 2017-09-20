class RemoveCommentFromPlacements < ActiveRecord::Migration[4.2]
  def change
    remove_column :refugees, :comment
  end
end
