$ ->
  $('.datepicker .input-group.date').datepicker
    weekStart: 1
    language: 'sv'
    autoclose: true
    todayHighlight: true
    todayBtn: true
    orientation: 'left bottom'
    keyboardNavigation: false

  register_dob_cal = () ->
    $('.dob.date input').datepicker
      weekStart: 1
      language: 'sv'
      autoclose: true
      todayHighlight: true
      todayBtn: true
      orientation: 'left bottom'
      keyboardNavigation: false

  register_dob_cal()


  # Do you want to leave this page confirm
  $form = $('form.simple_form.basic.refugee')
  if $form.length
    $(window).bind 'beforeunload', (e) ->
      'Dina ändringar kommer att gå förlorade'
    $form.bind 'submit', (e) ->
      $(window).unbind 'beforeunload'

  # Add term
  $("form.refugee").on "click", ".add-term", (event) ->
    event.preventDefault()
    regexp = new RegExp($(@).data('id'), 'g')
    $(@).closest(".form-group")
      .before($(@).data('fields').replace(regexp, new Date().getTime()))
    register_dob_cal()

  # Remove term
  $("form.refugee .terms").on "click", ".remove", (event) ->
    event.preventDefault()
    $(@).closest(".controls").find("input[type=hidden]").val(true)
    $(@).closest(".form-group").hide()

  $("#query-refugee").focus()

  # Load more search results
  $("section.search.refugees").on "click", ".load-more input", (event) ->
    event.preventDefault()
    $trigger = $(@)
    $trigger.val("Hämtar fler...").addClass('disabled')

    $.get $trigger.attr('data-path'), (data) ->
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
            label: "#{item.name} #{item.dossier_numbers.concat(item.ssns).join(', ')}"
            id: item.id
    select: (event, ui) ->
      $('#relationship_related_id').attr('value', ui.item.id)
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
                $.extend(item, { value: item.name })
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
        .append("<a>#{item.name} #{item.dossier_numbers.concat(item.ssns).join(', ')}</a>")
        .appendTo(ul).after($more)
