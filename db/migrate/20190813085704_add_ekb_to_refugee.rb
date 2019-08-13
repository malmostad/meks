class AddEkbToRefugee < ActiveRecord::Migration[5.2]
  def change
    add_column :refugees, :ekb, :boolean, default: true
  end
end
