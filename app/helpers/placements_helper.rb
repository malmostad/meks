module PlacementsHelper
  def add_placement_extra_costs_button(name, form)
    new_placement_extra_cost = PlacementExtraCost.new
    id = new_placement_extra_cost.object_id
    fields = form.simple_fields_for(:placement_extra_costs, new_placement_extra_cost, child_index: id) do |pec|
      render('fields_for_placement_extra_cost', pec: pec)
    end
    form.button :button, type: :button, name: nil, class: "btn btn-default add-term", data: { id: id, fields: fields.gsub("\n", "") } do
      name
    end
  end
end
