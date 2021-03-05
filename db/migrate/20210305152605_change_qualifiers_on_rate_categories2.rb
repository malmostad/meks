class ChangeQualifiersOnRateCategories2 < ActiveRecord::Migration[6.0]
  def up
    change_column :rate_categories, :qualifier, :string
    add_column :rate_categories, :min_age, :integer
    add_column :rate_categories, :max_age, :integer
  end

  def down
    change_column :rate_categories, :qualifier, :integer
    remove_column :rate_categories, :min_age, :integer
    remove_column :rate_categories, :max_age, :integer
  end
end
