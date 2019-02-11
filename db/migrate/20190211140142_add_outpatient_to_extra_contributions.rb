class AddOutpatientToExtraContributions < ActiveRecord::Migration[5.2]
  def change
    add_column :extra_contributions, :monthly_cost, :decimal, precision: 10, scale: 2
    add_column :extra_contributions, :comment, :string
  end
end
