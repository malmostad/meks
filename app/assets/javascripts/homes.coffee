$ ->
  daysInRange = (startDate, endData)  ->
    oneDay = 24*60*60*1000
    startDate = new Date("Jan 01 2017")
    endDate = new Date("Mar 31 2017")
    days = Math.round(Math.abs((startDate.getTime() - endDate.getTime())/(oneDay)))
    days++ # includes both start and end date

  toCost = (group) ->
    days = daysInRange(startDate, endData)
    x = [startDate, endData, seats]
    days / seats

  $form = $('body.homes form')
  $cost = $form.find('.home_costs_amount')

  setSpecificationField = ->
    $specification = $form.find('.placement_specification')

  setTotalCost = ->
    # 'TODO'

  recalculate = ->
    # 'TODO'

  $cost.find('input').change ->
    recalculate()

  $(window).load ->
    setTotalCost()
