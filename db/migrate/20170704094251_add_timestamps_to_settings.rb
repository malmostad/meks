class AddTimestampsToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :updated_at, :datetime, null: false
    add_column :settings, :created_at, :datetime, null: false
  end
end
