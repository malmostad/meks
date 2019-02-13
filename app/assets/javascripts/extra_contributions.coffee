$ ->
  $form = $('body.extra_contributions form')
  $select = $('#extra_contribution_extra_contribution_type_id')

  adaptForm = ->
    if $select.find(':selected').attr('data-special-case') is 'true'
      $form.find('.normal_case').hide()
      $form.find('.outpatient').show()
    else if $select.find(':selected').attr('data-special-case') is 'false'
      $form.find('.normal_case').show()
      $form.find('.outpatient').hide()
    else
      $form.find('.normal_case').hide()
      $form.find('.outpatient').hide()

  $select.change ->
    adaptForm()

  $(window).load ->
    adaptForm()
