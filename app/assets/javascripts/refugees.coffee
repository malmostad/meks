$ ->
  # Add term
  $("form.refugee").on "click", ".add-term", (event) ->
    event.preventDefault()
    regexp = new RegExp($(@).data('id'), 'g')
    $(@).closest(".form-group")
      .before($(@).data('fields').replace(regexp, new Date().getTime()))
      .prev().find("input").focus()

  # Remove term
  $("form.refugee .terms").on "click", ".remove", (event) ->
    event.preventDefault()
    $(@).closest(".controls").find("input[type=hidden]").val(true)
    $(@).closest(".form-group").hide()
