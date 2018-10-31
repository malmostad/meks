class AddArrivalToRefugee < ActiveRecord::Migration[5.2]
  def change
    add_column :refugees, :arrival, :boolean
  end
end
