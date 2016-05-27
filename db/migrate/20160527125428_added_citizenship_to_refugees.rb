class AddedCitizenshipToRefugees < ActiveRecord::Migration
  def change
    add_reference :refugees, :citizenship, index: true
    add_column :refugees, :citizenship_at, :date
  end
end
