module RateCategoriesHelper
  def add_rates_button(name, form)
    new_rate = Rate.new
    id = new_rate.object_id
    fields = form.simple_fields_for(:rates, new_rate, child_index: id) do |s|
      render('fields_for_rate', s: s)
    end
    form.button :button, type: :button, name: nil, class: 'btn btn-default add-term', data: { id: id, fields: fields.gsub("\n", '') } do
      name
    end
  end
end
