class ChangeExtensionOnSsn < ActiveRecord::Migration[4.2]
  def up
    change_column :ssns, :extension, :string
  end
  def down
    change_column :ssns, :extension, :integer
  end
end
