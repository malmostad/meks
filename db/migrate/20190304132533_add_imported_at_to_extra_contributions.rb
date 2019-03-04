class AddImportedAtToExtraContributions < ActiveRecord::Migration[5.2]
  def change
    add_column :extra_contributions, :imported_at, :datetime
  end
end
