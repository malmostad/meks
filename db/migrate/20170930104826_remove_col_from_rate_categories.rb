class RemoveColFromRateCategories < ActiveRecord::Migration[5.1]
  def change
    remove_column :rate_categories, :string
  end
end
