class ChangeSsnExtensionOnRefugees < ActiveRecord::Migration[4.2]
  def up
    change_column :refugees, :ssn_extension, :string
  end
  def down
    change_column :refugees, :ssn_extension, :integer
  end
end
