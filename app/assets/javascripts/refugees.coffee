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

  $("#query-refugee").focus()

  # Search results, load more
  $("section.search.refugees").on "click", ".load-more input", (event) ->
    event.preventDefault()
    $trigger = $(@)
    $trigger.val("Hämtar fler...").addClass('disabled')

    $.get $trigger.attr('data-path'), (data) ->
      $('.load-more').replaceWith($(data).find('.load-more'))
      $(data).find('tbody tr').appendTo('table.results tbody')
