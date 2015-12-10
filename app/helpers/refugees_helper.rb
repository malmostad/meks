module RefugeesHelper
  # TODO: refactor

  def add_dossier_numbers_button(name, form)
    new_dossier_number = DossierNumber.new
    id = new_dossier_number.object_id
    fields = form.simple_fields_for(:dossier_numbers, new_dossier_number, child_index: id) do |s|
      render("fields_for_dossier_numbers", s: s)
    end
    form.button :button, type: :button, name: nil, class: "btn btn-default add-term", data: {id: id, fields: fields.gsub("\n", "")} do
      "Lägg till"
    end
  end

  def add_ssns_button(name, form)
    new_ssn = Ssn.new
    id = new_ssn.object_id
    fields = form.simple_fields_for(:ssns, new_ssn, child_index: id) do |s|
      render("fields_for_ssns", s: s)
    end
    form.button :button, type: :button, name: nil, class: "btn btn-default add-term", data: {id: id, fields: fields.gsub("\n", "")} do
      "Lägg till"
    end
  end
end
