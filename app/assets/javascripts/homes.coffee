$ ->
  daysInRange = (startDate, endData)  ->
    oneDay = 24*60*60*1000
    startDate = new Date("Jan 01 2017")
    endDate = new Date("Mar 31 2017")
    days = Math.round(Math.abs((startDate.getTime() - endDate.getTime())/(oneDay)))
    days++ # includes both start and end date

  toDailyFee = (group) ->
    days = daysInRange(startDate, endData)
    x = [startDate, endData, seats]
    days / seats

  $form = $('body.homes form')
  $dailyFees = $form.find('.home_daily_fees_fee')

  setSpecificationField = ->
    $specification = $form.find('.placement_specification')

  setTotalFee = ->
    # 'TODO'

  $dailyFees.find('input').change ->
    recalculate()

  $(window).load ->
    setTotalFee()
