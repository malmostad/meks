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
      $('#placement_specification').val('')

  setFieldsForTypeOfCost = ->
    if $homeSelect.find(':selected').attr('data-type-of-cost') is 'per_day'
      $placementCost.hide()
      $placementCostField.val('')
    else if $homeSelect.find(':selected').attr('data-type-of-cost') is 'per_placement'
      $placementCost.show()
    else if $homeSelect.find(':selected').attr('data-type-of-cost') is 'for_family_and_emergency_home'
      console.log 'for_family_and_emergency_home'

  $homeSelect.change ->
    setSpecificationField()
    setFieldsForTypeOfCost()

  $(window).load ->
    setSpecificationField()
    setFieldsForTypeOfCost()
