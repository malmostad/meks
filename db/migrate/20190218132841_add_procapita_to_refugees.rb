class AddProcapitaToRefugees < ActiveRecord::Migration[5.2]
  def change
    add_column :refugees, :procapita, :string
  end
end
