class CreateExtraContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :extra_contributions do |t|
      t.references :refugee, index: true, foreign_key: true, type: :integer
      t.references :extra_contribution_type, index: true, foreign_key: true
      t.date :period_start
      t.date :period_end
      t.decimal :fee, precision: 10, scale: 2, default: 0
      t.decimal :expense, precision: 10, scale: 2, default: 0

      t.timestamps
    end
  end
end
