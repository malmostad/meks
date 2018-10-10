class CreateExtraContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :extra_contributions do |t|
      t.references :refugee, index: true, foreign_key: true, type: :integer
      t.references :extra_contribution_type, index: true, foreign_key: true
      t.date :period_start
      t.date :period_end
      t.decimal :fee, precision: 8, scale: 2
      t.decimal :expense, precision: 8, scale: 2

      t.timestamps
    end
  end
end
