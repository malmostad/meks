class AddCommentToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :comment, :string
    remove_column :payments, :diarie
  end
end
