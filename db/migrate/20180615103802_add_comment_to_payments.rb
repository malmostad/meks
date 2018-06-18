class AddCommentToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :comment, :text
    remove_column :payments, :diarie
  end
end
