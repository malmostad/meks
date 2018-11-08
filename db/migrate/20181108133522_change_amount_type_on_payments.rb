class ChangeAmountTypeOnPayments < ActiveRecord::Migration[5.2]
  def up
    change_column :payments, :amount, :decimal, precision: 12, scale: 2
  end

  def down
    change_column :payments, :amount, :decimal, precision: 8, scale: 2
  end
end
