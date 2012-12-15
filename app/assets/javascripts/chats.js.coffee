# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

notifyTyping = (chatId, msg) ->

  $.ajax({
    url: "/chats/#{ chatId }/status"
    data: {
      status: msg
      socket_id: pusher.connection.socket_id
    },
    type: 'post'
    success: ->
      console.log('typing success', arguments)
    error: ->
      console.error('error', arguments)
  })

$ ->
  $('.review_mode').on 'ajax:success', (event, data) ->
    if data.message_id
      $("#message_#{data.message_id}").find(".like_button, .unlike_button").toggle()


  channel.bind('chat_typing_event', (data) ->

    if (data == 'typing')
      $('<p>', {
        class: 'message'
        id: 'typing_msg'
      }).html('...').appendTo($("#messages"))
    else
      $("#typing_msg").remove()

    console.log('chat typing event', data)
  )

  typingTimer = 0
  isTyping = false
  chatId = $('#messages').data('id')

  $('#message_content').keyup (event) ->
    clearTimeout(typingTimer) unless typingTimer

    if $(this).val() == '' && isTyping
      isTyping = false
      notifyTyping(chatId, 'stopped_typing')
      clearTimeout(typingTimer)

    if $(this).val() != '' && !isTyping
      isTyping = true
      notifyTyping(chatId, 'typing')
      typingTimer = setTimeout ->
        isTyping = false
        notifyTyping(chatId, 'stopped_typing')
      , 2000

