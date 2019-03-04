class AddImportedAtToPlacements < ActiveRecord::Migration[5.2]
  def change
    add_column :placements, :imported_at, :datetime
  end
end
