class CreateDeassignments < ActiveRecord::Migration
  def change
    create_table :deassignments do |t|
      t.belongs_to :home, index: true
      t.belongs_to :refugee, index: true
      t.date :moved_out_at
      t.references :deassignment_reason, index: true, foreign_key: true
      t.text :comment

      t.timestamps null: false
    end
  end
end
