class ChangeSsnExtensionOnRefugees < ActiveRecord::Migration
  def up
    change_column :refugees, :ssn_extension, :string
  end
  def down
    change_column :refugees, :ssn_extension, :integer
  end
end
