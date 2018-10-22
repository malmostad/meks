$ ->
  $addPlacementCost = $('.form-group.add-cost')

  # Remove home costs if use_placement_cost
  $("form").on "change", "#home_type_of_cost", (event) ->
    if $(@).val() != 'per_day'
      $('.terms.cost').find('.fields_for_group').hide().find("input[type=hidden]").val(true)
      $addPlacementCost.hide()
    else
      $addPlacementCost.show()

  $(window).load ->
    if $('#home_type_of_cost').val() != 'per_day'
      $addPlacementCost.hide()

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
