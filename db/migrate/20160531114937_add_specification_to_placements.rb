class AddSpecificationToPlacements < ActiveRecord::Migration
  def change
    add_column :homes, :use_placement_specification, :boolean, default: false
    add_column :placements, :specification, :text
  end
end
