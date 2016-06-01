class AddCitizenshipDateToRefugees < ActiveRecord::Migration
  def change
    add_column :refugees, :citizenship_at, :date
  end
end
