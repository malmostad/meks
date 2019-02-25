class AddImportedAtToRefugees < ActiveRecord::Migration[5.2]
  def change
    add_column :refugees, :imported_at, :datetime
  end
end
