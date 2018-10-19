class AddCostModelToHomes < ActiveRecord::Migration[5.2]
  def up
    # enums in model: :per_day :per_placement :for_family_and_emergency_home
    add_column :homes, :type_of_cost, :integer

    # Migrates from old boolean setting use_placement_cost to new model enum setting
    Home.find_each do |home|
      if home.use_placement_cost
        home.update_attribute(:type_of_cost, :per_placement)
      else
        home.update_attribute(:type_of_cost, :per_day)
      end
    end

    remove_column :homes, :use_placement_cost
  end

  def down
    add_column :homes, :use_placement_cost, :boolean, default: false

    # Migrates to old boolean setting use_placement_cost from new model enum setting
    # for_family_and_emergency_home will set use_placement_cost to false
    Home.find_each do |home|
      home.update_attribute(:use_placement_cost, home.use_placement_cost?)
    end

    remove_column :homes, :type_of_cost
  end
end
