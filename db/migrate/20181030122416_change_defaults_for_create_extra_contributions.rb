class ChangeDefaultsForCreateExtraContributions < ActiveRecord::Migration[5.2]
  def up
    change_column :extra_contributions, :fee, :decimal, precision: 10, scale: 2, default: nil
    change_column :extra_contributions, :expense, :decimal, precision: 10, scale: 2, default: nil
  end

  def down
    change_column :extra_contributions, :fee, :decimal, precision: 10, scale: 2, default: 0
    change_column :extra_contributions, :expense, :decimal, precision: 10, scale: 2, default: 0
  end
end
