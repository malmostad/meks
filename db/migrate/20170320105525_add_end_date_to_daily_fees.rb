class AddEndDateToDailyFees < ActiveRecord::Migration[5.0]
  def change
    add_column :daily_fees, :end_date, :date
  end
end
