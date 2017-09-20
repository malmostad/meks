$ ->
  $(document).on "click", "[data-confirm]", (event) ->
    message = @getAttribute('data-confirm')
    unless window.confirm(message)
      event.preventDefault()
