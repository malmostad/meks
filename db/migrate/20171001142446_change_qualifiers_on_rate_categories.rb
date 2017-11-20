class ChangeQualifiersOnRateCategories < ActiveRecord::Migration[5.1]
  def up
    remove_column :rate_categories, :base_qualifier
    remove_column :rate_categories, :min_age
    remove_column :rate_categories, :max_age
    add_column :rate_categories, :qualifier, :integer
  end

  def down
    add_column :rate_categories, :base_qualifier, :string
    add_column :rate_categories, :min_age, :integer
    add_column :rate_categories, :max_age, :integer
    remove_column :rate_categories, :qualifier
  end
end
