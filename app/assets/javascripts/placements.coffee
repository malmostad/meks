$ ->
  $form = $('body.placements form')
  $homeSelect = $('#placement_home_id')
  $placementCost = $form.find('.placement_cost')

  setSpecificationField = ->
    $specification = $form.find('.placement_specification')
    if $homeSelect.find(':selected').attr('data-use-specification') is 'true'
      $specification.show()
    else
      $specification.hide()

  setCostField = ->
    if $homeSelect.find(':selected').attr('data-use-placement-cost') is 'true'
      $placementCost.show()
    else
      $placementCost.hide()

  $homeSelect.change ->
    setSpecificationField()
    setCostField()

  $(window).load ->
    setCostField()
