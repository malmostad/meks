$ ->
  $('.input-group.date').datepicker
    weekStart: 1
    language: 'sv'
    autoclose: true
    todayHighlight: true

  $('select.chosen')
   .attr 'data-placeholder', 'Skriv och välj'
   .chosen
     no_results_text: 'Ingen träff på'
     width: '100%'
