class AddCitizenshipDateToRefugees < ActiveRecord::Migration[4.2]
  def change
    add_column :refugees, :citizenship_at, :date
  end
end
