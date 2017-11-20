class AddQualifierAndAgeToRateCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :rate_categories, :base_qualifier, :string
    add_column :rate_categories, :min_age, :integer
    add_column :rate_categories, :max_age, :integer
  end
end
