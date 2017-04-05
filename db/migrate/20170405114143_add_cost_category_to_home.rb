class AddCostCategoryToHome < ActiveRecord::Migration[5.0]
  def change
    add_column :homes, :cost_category, :string
  end
end
