module HomesHelper
  def add_costs_button(name, form)
    new_cost = Cost.new
    id = new_cost.object_id
    fields = form.simple_fields_for(:costs, new_cost, child_index: id) do |s|
      render('fields_for_cost', s: s)
    end
    form.button :button, type: :button, name: nil, class: 'btn btn-default add-term', data: { id: id, fields: fields.gsub("\n", '') } do
      name
    end
  end

  def home_and_type_of_cost(home)
    "#{home.name} (#{I18n.t('simple_form.options.home.type_of_cost.' + home.type_of_cost)})"
  end
end
