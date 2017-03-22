$ ->
  $form = $('body.placements form')
  $homeSelect = $('#placement_home_id')

  setSpecificationField = ->
    $specification = $form.find('.placement_specification')

    if $homeSelect.find(':selected').attr('data-use-specification') is 'true'
      $specification.show()
    else
      $specification.hide()

  $homeSelect.change ->
    setSpecificationField()

  $(window).load ->
    setSpecificationField()

  daysInRange = (startDate, endData)  ->
    oneDay = 24*60*60*1000
    startDate = new Date("Jan 01 2017")
    endDate = new Date("Mar 31 2017")
    days = Math.round(Math.abs((startDate.getTime() - endDate.getTime())/(oneDay)))
    days + 1 # includes both start and end date

  toDailyFee = (startDate, endData, seats)  ->
    days = daysInRange(startDate, endData)
    days / seats
