class CreateDeassignmentReasons < ActiveRecord::Migration
  def change
    create_table :deassignment_reasons do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
