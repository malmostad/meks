class AddOutpatientToExtraContributionTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :extra_contribution_types, :outpatient, :boolean, default: false
  end
end
