# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  $("#new_sentence_content").on "keyup", ->
    limit = $("#chars_limit").val()
    char_limit = parseInt(limit, 10)
    words = $(this).val().length
    wordsRemaining = char_limit - words
    $("#display_count").text  wordsRemaining
    return
    
  $("#leave_group").on "click",(ev) ->
    ev.preventDefault();
    $('.basic.modal').modal('show');
    return
    
  $(".cancel_button").on "click", (ev) ->
    ev.preventDefault();
    $('.basic.modal').modal('show');
    return
    
  $(".okay_button").on "click", (ev) ->
    ev.preventDefault()
    $.post $("#leave_group").attr("href"), (response) ->
      if response is true
        $(".basic.modal").modal "hide"
      else
        $("#leaving_error").text "Server error! Please contact admin!"
      return

    return
return
    
  
