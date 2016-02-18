class CreateDeregisteredReasons < ActiveRecord::Migration
  def change
    create_table :deregistered_reasons do |t|
      t.string :name
    end
    add_index :deregistered_reasons, :name, unique: true
  end
end
