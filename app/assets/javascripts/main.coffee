$ ->
  $('select.chosen')
   .attr 'data-placeholder', 'Skriv och välj'
   .chosen
     no_results_text: 'Ingen träff på'
     width: '100%'

  $('body.login #username').focus()
