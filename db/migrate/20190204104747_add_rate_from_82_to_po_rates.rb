class AddRateFrom82ToPoRates < ActiveRecord::Migration[5.2]
  def change
    rename_column :po_rates, :rate_from_65, :rate_between_65_and_81
    add_column :po_rates, :rate_from_82, :decimal, precision: 5, scale: 2
  end
end
