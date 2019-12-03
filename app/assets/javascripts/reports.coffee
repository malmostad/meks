$ ->
  $('.input-group.input-daterange').datepicker
    weekStart: 1
    language: 'sv'
    autoclose: true
    todayHighlight: true
    todayBtn: true
    orientation: 'auto'
    keyboardNavigation: false
  .find('input')
  .attr('autocomplete', 'off')

  # Check and update download status
  $reportsStatus = $('.reports.status')
  $timer = $('.reports.status .timer')
  if $timer.length
    $time = $timer.find('span')
    $queue = $('.reports.status .queue span')
    createdAt = $timer.attr('data-created-at')
    statusUrl = $timer.attr('data-status-url')

    counter = setInterval (->
      date = new Date(null)
      secondsPassed = Math.round((new Date).getTime() / 1000 - createdAt)
      date.setSeconds(secondsPassed)
      $time.text date.toISOString().substr(14, 5)
      return
    ), 1000

    poll = setInterval (->
      $.getJSON statusUrl, (status) ->
        $queue.text status.queue_size
        if status.failed
          clearInterval(counter)
          clearInterval(poll)
          $('.reports.status .generating').hide()
          $('.reports.status .download.error').addClass('true')

        else if status.finished
          clearInterval(counter)
          clearInterval(poll)
          $('.reports.status .generating').hide()
          $('.reports.status .download.finished').addClass('true')
        return
      return
    ), 2000
