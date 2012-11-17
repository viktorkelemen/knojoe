# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.review_mode').on 'ajax:success', (event, data) ->
    if data.message_id
      $("#message_#{data.message_id}").find(".like_button, .unlike_button").toggle()