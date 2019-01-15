class CreatePoRates < ActiveRecord::Migration[5.2]
  def change
    create_table :po_rates do |t|
      t.decimal :rate_under_65, precision: 5, scale: 2
      t.decimal :rate_from_65, precision: 5, scale: 2
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
