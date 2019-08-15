$ ->
  # Used for both placement form and person_placement form
  $form = $('body.placements form, body.people form')
  $homeSelect = $('#placement_home_id, #person_placements_attributes_0_home_id')
  $placementCost = $form.find('.placement_cost, .person_placements_cost')
  $placementCostField = $form.find('#placement_cost, #person_placements_attributes_0_cost')
  $familyAndEmergencyHomeCosts = $form.find('.family_and_emergency_home_costs')

  setSpecificationField = ->
    $specification = $form.find('.placement_specification, .person_placements_specification')
    if $homeSelect.find(':selected').attr('data-use-specification') is 'true'
      $specification.show()
    else
      $specification.hide()

  setFieldsForTypeOfCost = ->
    if $homeSelect.find(':selected').attr('data-type-of-cost') is 'cost_per_day'
      $placementCost.hide()
      $familyAndEmergencyHomeCosts.hide()
    else if $homeSelect.find(':selected').attr('data-type-of-cost') is 'cost_per_placement'
      $placementCost.show()
      $familyAndEmergencyHomeCosts.hide()
    else if $homeSelect.find(':selected').attr('data-type-of-cost') is 'cost_for_family_and_emergency_home'
      $placementCost.hide()
      $familyAndEmergencyHomeCosts.show()
    else
      $placementCost.hide()
      $familyAndEmergencyHomeCosts.hide()

  $homeSelect.change ->
    setSpecificationField()
    setFieldsForTypeOfCost()

  $(window).load ->
    setSpecificationField()
    setFieldsForTypeOfCost()
