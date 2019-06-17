class AddTransferredToRefugee < ActiveRecord::Migration[5.2]
  def change
    add_column :refugees, :transferred, :boolean
  end
end
