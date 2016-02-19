class AddSecrecyToRefugee < ActiveRecord::Migration
  def change
    add_column :refugees, :secrecy, :boolean, default: false
  end
end
