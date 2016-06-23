class ChangeExtensionOnSsn < ActiveRecord::Migration
  def up
    change_column :ssns, :extension, :string
  end
  def down
    change_column :ssns, :extension, :integer
  end
end
