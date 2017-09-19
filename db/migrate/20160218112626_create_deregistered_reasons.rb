class CreateDeregisteredReasons < ActiveRecord::Migration[4.2]
  def change
    create_table :deregistered_reasons do |t|
      t.string :name
    end
    add_index :deregistered_reasons, :name, unique: true
  end
end
