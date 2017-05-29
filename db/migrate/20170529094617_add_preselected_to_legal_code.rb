class AddPreselectedToLegalCode < ActiveRecord::Migration[5.0]
  def change
    add_column :legal_codes, :pre_selected, :boolean, default: false
  end
end
