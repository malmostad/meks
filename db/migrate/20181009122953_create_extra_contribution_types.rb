class CreateExtraContributionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :extra_contribution_types do |t|
      t.string :name

      t.timestamps null: false
    end

    add_index :extra_contribution_types, :name, unique: true
  end
end
