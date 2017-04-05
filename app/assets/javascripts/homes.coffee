$ ->
  # Remove costs when cost category is 'not_hvb'
  # Add button when cost category is 'hvb'
  $("body").on "change", "#home_cost_category", (event) ->
    event.preventDefault()
    $terms = $(@).closest(".form-group").next('.terms')
    if $(@).val() is 'not_hvb'
      $terms.find(".form-group.home_costs_amount input[type=hidden]").val(true)
      $terms.find(".form-group.home_costs_amount").hide()
      $terms.find("button.add-term").hide()
    else
      $terms.find(".add-term").show()

  # Hide the add cost button on load if category is 'not_hvb'
  $costCategory = $("#home_cost_category")
  if $costCategory.val() is 'not_hvb'
    $costCategory.closest(".form-group").next('.terms').find(".add-term").hide()


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
