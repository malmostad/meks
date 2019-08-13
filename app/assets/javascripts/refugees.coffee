$ ->
  # Do you want to leave this page prompt
  $form = $('form.simple_form.basic.refugee')
  if $form.length
    $(window).bind 'beforeunload', (event) ->
      'Dina ändringar kommer att gå förlorade'
    $form.bind 'submit', (event) ->
      $(window).unbind 'beforeunload'
    $('.btn-danger').bind 'click', (event) ->
      $(window).unbind 'beforeunload'

  $relationship_related = $("#relationship_related")
  $relationship_related.autocomplete
    source: (request, response) ->
      $.ajax
        url: $relationship_related.attr('data-autocomplete-url')
        dataType: "jsonp"
        data:
          term: request.term.toLowerCase()
          items: 10
        success: (data) ->
          response $.map data, (item) ->
            value: item.value
            id: item.id
    select: (event, ui) ->
      event.preventDefault()
      $('#relationship_related_id').val(ui.item.id)
      $('#relationship_related_name').val(ui.item.value)
      $('#relationship_related').val('')
    minLength: 2
