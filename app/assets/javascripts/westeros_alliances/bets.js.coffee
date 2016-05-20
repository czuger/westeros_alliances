# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$(document).ready ->
  $("input[name=asking_house_id]:radio").change ->
    asking_house_id = $('input[name=asking_house_id]:checked').val()
    # console.log( asking_house_id )

    bets = $.parseJSON( $('#bets').val() );
    house_bets = bets[ asking_house_id ]
    # console.log( house_bets )

    $( '.house_bets_inputs' ).val( '' )
    # console.log( $( '.house_bets_inputs' ) )

    for house_id, bet of house_bets
      # console.log( house_id, bet )
      # console.log( $( "#houses_bets_#{house_id}" ) )
      if bet > 0
        $( "#houses_bets_#{house_id}" ).val( "#{bet}" )

