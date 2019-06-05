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

  $("#query-refugee").focus()

  # Load more search results
  $("section.search.refugees").on "click", ".load-more a", (event) ->
    event.preventDefault()
    $trigger = $(@)
    $trigger.text("Hämtar fler...").addClass('disabled')

    $.get $trigger.attr('href'), (data) ->
      $('.load-more').replaceWith($(data).find('.load-more'))
      $(data).find('tbody tr').appendTo('table.results tbody')

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


  # Autocomplete on refugee search
  # Well, this is a little bit too much
  items = 0
  requestTerm = ''
  $queryRefugeeField = $('#query-refugee')
  if $queryRefugeeField.length
    $queryRefugeeField.autocomplete
      source: (request, response) ->
        requestTerm = request.term
        $.ajax
          url: $queryRefugeeField.attr('data-autocomplete-url')
          data:
            term: request.term.toLowerCase()
          dataType: "jsonp"
          timeout: 5000
          success: (data) ->
            if data.length
              items = data.length
              response $.map data, (item) ->
                $.extend(item, { value: item.value })
                item
            else
              $queryRefugeeField.autocomplete("close")
      minLength: 2
      select: (event, ui) ->
        if ui.item.path is "full-search"
          $queryRefugeeField.closest("form").submit()
        else
          document.location = ui.item.path
      open: ->
        $("ul.ui-menu").width $(@).innerWidth()
    .data("ui-autocomplete")._renderItem = (ul, item) ->
      # Create item for full search we reached the last item
      $more = ""
      if items is ul.find("li").length + 1
        $more = $("<li class='more-search-results ui-menu-item' role='presentation'><a>Visa alla träffar</a></li>")
          .data("ui-autocomplete-item", { path: "full-search", value: requestTerm})
      ul.addClass('search-refugees')
      $("<li>")
        .data("ui-autocomplete-item", item)
        .append("<a>#{item.value}</a>")
        .appendTo(ul).after($more)
