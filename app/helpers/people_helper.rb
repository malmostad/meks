module PeopleHelper
  def asylum_status(person)
    asylum = person.asylum
    return 'Ingen status' if asylum.blank?

    I18n.t('simple_form.labels.person.' + asylum.first) + ' ' + asylum.second.to_s
  end

  def add_dossier_numbers_button(name, form)
    new_dossier_number = DossierNumber.new
    id = new_dossier_number.object_id
    fields = form.simple_fields_for(:dossier_numbers, new_dossier_number, child_index: id) do |s|
      render('fields_for_dossier_number', s: s)
    end
    form.button :button, type: :button, name: nil, class: 'btn btn-default add-term', data: { id: id, fields: fields.gsub("\n", '') } do
      name
    end
  end

  def add_ssns_button(name, form)
    new_ssn = Ssn.new
    id = new_ssn.object_id
    fields = form.simple_fields_for(:ssns, new_ssn, child_index: id) do |s|
      render('fields_for_ssn', s: s)
    end
    form.button :button, type: :button, name: nil, class: 'btn btn-default add-term', data: { id: id, fields: fields.gsub("\n", '') } do
      name
    end
  end

  def po_extra(cost)
    po_cost = Economy::CostWithPoRate.new(cost).as_array.sum { |x| x[:po_cost] }
    number_to_currency(po_cost || 0, delimiter: ' ')
  end
end
