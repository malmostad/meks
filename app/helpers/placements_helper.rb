module PlacementsHelper
  def add_placement_extra_costs_button(name, form)
    new_placement_extra_cost = PlacementExtraCost.new
    id = new_placement_extra_cost.object_id
    fields = form.simple_fields_for(:placement_extra_costs, new_placement_extra_cost, child_index: id) do |pec|
      render('fields_for_placement_extra_cost', pec: pec)
    end
    form.button :button, type: :button, name: nil, class: 'btn btn-sm add-term', data: { id: id, fields: fields.gsub("\n", '') } do
      name
    end
  end

  def add_family_and_emergency_home_costs_button(name, form)
    new_family_and_emergency_home_cost = FamilyAndEmergencyHomeCost.new
    id = new_family_and_emergency_home_cost.object_id
    fields = form.simple_fields_for(:family_and_emergency_home_costs, new_family_and_emergency_home_cost, child_index: id) do |fae|
      render('fields_for_family_and_emergency_home_cost', fae: fae)
    end
    form.button :button, type: :button, name: nil, class: 'btn btn-sm add-term', data: { id: id, fields: fields.gsub("\n", '') } do
      name
    end
  end

  def family_and_emergency_home_cost(cost)
    period = "#{cost.period_start}–#{cost.period_end}"
    expense = number_to_currency(cost.expense || 0, delimiter: ' ')

    po_costs = Economy::CostWithPoRate.new(cost).as_array.sum { |x| x[:po_cost] }
    po_costs = number_to_currency(po_costs || 0, delimiter: ' ')
    fee = number_to_currency(cost.fee || 0, delimiter: ' ')

    "Avtalsperiod: #{period}, arvode: #{fee}, arbetsgivaravgift: #{po_costs}, omkostnad: #{expense},
    uppdragstagare: #{cost.contractor_name},
    uppdragstagares födelsedag: #{cost.contractor_birthday},
    uppdragstagares anställningsnummer: #{cost.contactor_employee_number}"
  end

  def extra_cost(cost)
    amount = number_to_currency(cost.amount || 0, delimiter: ' ')

    "Datum: #{cost.date}, belopp: #{amount}, kommentar: #{cost.comment}"
  end
end
