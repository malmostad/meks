$ ->
  $('.input-group.input-daterange').datepicker
    weekStart: 1
    language: 'sv'
    autoclose: true
    todayHighlight: true
    endDate: 'today'

  $('select#home_id_')
   .chosen
     no_results_text: 'Ingen träff på'
     width: '200px'
