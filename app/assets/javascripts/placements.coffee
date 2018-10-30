$ ->
  # Used for both placement form and refugee_placement form
  $form = $('body.placements form, body.refugees form')
  $homeSelect = $('#placement_home_id, #refugee_placements_attributes_0_home_id')
  $placementCost = $form.find('.placement_cost, .refugee_placements_cost')
  $placementCostField = $form.find('#placement_cost, #refugee_placements_attributes_0_cost')

  setSpecificationField = ->
    $specification = $form.find('.placement_specification, .refugee_placements_specification')
    if $homeSelect.find(':selected').attr('data-use-specification') is 'true'
      $specification.show()
    else
      $specification.hide()

  setFieldsForTypeOfCost = ->
    if $homeSelect.find(':selected').attr('data-type-of-cost') is 'cost_per_day'
      $placementCost.hide()
    else if $homeSelect.find(':selected').attr('data-type-of-cost') is 'cost_per_placement'
      $placementCost.show()
    else if $homeSelect.find(':selected').attr('data-type-of-cost') is 'cost_for_family_and_emergency_home'
      $placementCost.hide()

  $homeSelect.change ->
    setSpecificationField()
    setFieldsForTypeOfCost()

  $(window).load ->
    setSpecificationField()
    setFieldsForTypeOfCost()
