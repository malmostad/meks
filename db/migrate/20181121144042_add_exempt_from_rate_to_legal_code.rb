class AddExemptFromRateToLegalCode < ActiveRecord::Migration[5.2]
  def change
    add_column :legal_codes, :exempt_from_rate, :boolean, default: false
  end
end
