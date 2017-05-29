class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.string :key
      t.string :human_name
      t.string :value
    end
    add_index :settings, :key, unique: true
  end
end
