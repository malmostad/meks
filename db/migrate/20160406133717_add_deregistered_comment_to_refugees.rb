class AddDeregisteredCommentToRefugees < ActiveRecord::Migration[4.2]
  def change
    add_column :refugees, :deregistered_comment, :text
  end
end
