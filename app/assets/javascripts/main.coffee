$ ->
  # Datepicker
  add_calendar = () ->
    $('input.date').datepicker
      weekStart: 1
      language: 'sv'
      autoclose: true
      todayHighlight: true
      todayBtn: true
      orientation: 'auto'
      keyboardNavigation: false
    .attr('autocomplete', 'off')

  add_calendar()

  # Fields for form parts
  # Add term
  $("form").on "click", ".terms .add-term", (event) ->
    event.preventDefault()
    regexp = new RegExp($(@).data('id'), 'g')
    $(@).closest(".form-group")
      .before($(@).data('fields').replace(regexp, new Date().getTime()))
    add_calendar()

  # Remove term
  $("body").on "click", ".terms .remove", (event) ->
    event.preventDefault()
    $(@).closest(".controls").find("input[type=hidden]").val(true)
    $(@).closest(".form-group").hide()

  # Chosen field (multi tags)
  $('select.chosen')
    .attr 'data-placeholder', 'Skriv och välj'
    .chosen
      no_results_text: 'Ingen träff på'
      width: '100%'
      allow_single_deselect: true

  $('body.login #username').focus()

  # Create a popover span
  $('[data-create="popover"]').append ->
    "<span
      class='icon-info'
      title='#{$(@).attr("title") || ""}'
      data-toggle='popover'
      data-content='#{$(@).attr("data-content")}'>"

  $('[data-toggle="popover"]').popover({container: 'body', placement: 'bottom'})

  # Prevent checkboxes from toggle on info click
  $(document).on 'click', '.icon-info', (event) ->
    event.preventDefault()

  # Hide popover on esc
  $(document).on 'keydown', (event) ->
    if event.which is 27
      $('[data-toggle="popover"]').popover('hide')
