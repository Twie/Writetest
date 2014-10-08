# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#new_sentence_content").on "keyup", ->
    limit = $("#chars_limit").val()
    char_limit = parseInt(limit, 10)
    words = $(this).val().length
    wordsRemaining = char_limit - words
    $("#display_count").text  wordsRemaining
    return
