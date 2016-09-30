$ ->
  $('select.chosen')
    .attr 'data-placeholder', 'Skriv och välj'
    .chosen
      no_results_text: 'Ingen träff på'
      width: '100%'
      allow_single_deselect: true

  $('body.login #username').focus()
