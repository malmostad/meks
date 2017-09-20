class CreateTargetGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :target_groups do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :target_groups, :name, unique: true
  end
end
