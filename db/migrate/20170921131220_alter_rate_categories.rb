class AlterRateCategories < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :rate_categories, :legal_codes
    remove_index :rate_categories, :legal_code_id

    remove_column :rate_categories, :legal_code_id
    remove_column :rate_categories, :from_age
    remove_column :rate_categories, :to_age
    add_column :rate_categories, :human_name, :string
  end
end
