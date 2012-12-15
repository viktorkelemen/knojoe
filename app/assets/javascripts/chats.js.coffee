# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
notifyStoppedTyping = ->
  console.log('stopped typing')

notifyTyping = ->
  console.log('typing')

$ ->
  $('.review_mode').on 'ajax:success', (event, data) ->
    if data.message_id
      $("#message_#{data.message_id}").find(".like_button, .unlike_button").toggle()


  typingTimer = 0
  isTyping = false
  $('#message_content').keyup (event) ->
    clearTimeout(typingTimer) unless typingTimer

    if $(this).val() == '' && isTyping
      isTyping = false
      notifyStoppedTyping()
      clearTimeout(typingTimer)

    if $(this).val() != '' && !isTyping
      isTyping = true
      notifyTyping()
      typingTimer = setTimeout ->
        isTyping = false
        notifyStoppedTyping()
      , 2000
