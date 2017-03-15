module HomesHelper
  def add_daily_fees_button(name, form)
    new_daily_fee = DailyFee.new
    id = new_daily_fee.object_id
    fields = form.simple_fields_for(:daily_fees, new_daily_fee, child_index: id) do |s|
      render("fields_for_daily_fee", s: s)
    end
    form.button :button, type: :button, name: nil, class: "btn btn-default add-term", data: { id: id, fields: fields.gsub("\n", "") } do
      name
    end
  end
end
