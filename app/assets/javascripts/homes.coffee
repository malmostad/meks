$ ->
  $addPlacementCost = $('.form-group.add-cost, .terms.cost')

  # Remove home costs if use_placement_cost
  $("form").on "change", "#home_type_of_cost", (event) ->
    if $(@).val() != 'cost_per_day'
      $addPlacementCost.hide()
    else
      $addPlacementCost.show()

  $(window).load ->
    if $('#home_type_of_cost').val() != 'cost_per_day'
      $addPlacementCost.hide()
