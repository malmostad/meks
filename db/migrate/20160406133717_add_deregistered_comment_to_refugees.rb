class AddDeregisteredCommentToRefugees < ActiveRecord::Migration
  def change
    add_column :refugees, :deregistered_comment, :text
  end
end
