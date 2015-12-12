class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :home, index: true
      t.belongs_to :refugee, index: true
      t.date :moved_in_at
      t.date :moved_out_at
      t.references :moved_out_reason, index: true, foreign_key: true
      t.text :comment

      t.timestamps null: false
    end
  end
end
