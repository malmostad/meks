class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :home, index: true
      t.belongs_to :refugee, index: true
      t.date :moved_in_at

      t.timestamps null: false
    end
  end
end
