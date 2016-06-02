$ ->
  $form = $('body.placements form')
  $homeSelect = $('#placement_home_id')

  setSpecificationField = ->
    $specification = $form.find('.placement_specification')

    if $homeSelect.find(':selected').attr('data-use-specification') is 'true'
      $specification.show()
    else
      $specification.hide()

  $homeSelect.change ->
    setSpecificationField()

  $(window).load ->
    setSpecificationField()
