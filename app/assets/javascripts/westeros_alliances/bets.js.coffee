# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$(document).ready ->
  $("input[name=asking_house]:radio").change ->
    asking_house_id = $('input[name=asking_house]:checked').val()
    console.log( asking_house_id )


    