$ ->
  # Chosen field
  $('select.chosen')
    .attr 'data-placeholder', 'Skriv och välj'
    .chosen
      no_results_text: 'Ingen träff på'
      width: '100%'
      allow_single_deselect: true

  # Datepicker
  register_dob_cal = () ->
    $('.input-group.ssn.date input:first-child, .home_daily_fees_fee input.date').datepicker
      weekStart: 1
      language: 'sv'
      autoclose: true
      todayHighlight: true
      todayBtn: true
      orientation: 'auto'
      keyboardNavigation: false

  register_dob_cal()

  # Fields for form parts

  # Add term
  $("form.refugee, form.home").on "click", ".add-term", (event) ->
    event.preventDefault()
    regexp = new RegExp($(@).data('id'), 'g')
    $(@).closest(".form-group")
      .before($(@).data('fields').replace(regexp, new Date().getTime()))
    register_dob_cal()

  # Remove term
  $("form.refugee .terms, form.home .terms").on "click", ".remove", (event) ->
    event.preventDefault()
    $(@).closest(".controls").find("input[type=hidden]").val(true)
    $(@).closest(".form-group").hide()


  $('body.login #username').focus()
