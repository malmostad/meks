class AddSecrecyToRefugee < ActiveRecord::Migration[4.2]
  def change
    add_column :refugees, :secrecy, :boolean, default: false
  end
end
