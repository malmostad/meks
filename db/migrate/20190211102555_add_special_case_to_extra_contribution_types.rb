class AddSpecialCaseToExtraContributionTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :extra_contribution_types, :special_case, :boolean, default: false
  end
end
