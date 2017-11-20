class CreateMovedOutReasons < ActiveRecord::Migration[4.2]
  def change
    create_table :moved_out_reasons do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :moved_out_reasons, :name, unique: true
  end
end
