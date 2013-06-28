window.K = window.K || {};

notifyTyping = (chatId, msg) ->

  $.ajax({
    url: "/chats/#{ chatId }/status"
    data: {
      status: msg
      socket_id: pusher.connection.socket_id
    },
    type: 'post'
    error: ->
      console.error('error', arguments)
  })


insertAt = (src, index, str) ->
  src.substr(0, index) + str + src.substr(index)


hidePopup = (popup, btn) ->
  popup.addClass('hidden')
  btn.removeClass('active')

showPopup = (popup, btn) ->
  popup.removeClass('hidden')
  btn.addClass('active')

togglePopup = (popup, btn) ->
  if popup.hasClass('hidden')
    showPopup(popup, btn)
  else
    hidePopup(popup, btn)


K.updateTimerUI = (value) ->
  container = $('.timer_container')

  # the value is between 0 and 1
  h = Math.round(value * 58)
  if (h >= 58)
    h = 58
    container.addClass('warning')

  container
    .find('.timer')
    .css({ width: h + 'px' })
    .removeClass('hidden')

$ ->

  message_form = $('.message_form')
  emoji_popup = message_form.find('.emoji_popup')
  message_input = message_form.find('.message_input')
  emoji_btn = message_form.find('.emoji_btn')

  if message_form.length > 1
    initTimer(chatTimerOffset) if chatTimerOffset != -1

  emoji_btn.click (e) ->
    togglePopup(emoji_popup, emoji_btn)
    e.preventDefault()
    e.stopPropagation()

  emoji_popup.on 'click', '.emoji', (e) ->
    caret = message_input.caret()
    msg = message_input.val()
    emoji_txt = " #{ $(this).data('value') } "
    message_input.val(insertAt(msg, caret, emoji_txt))
    message_input.focus().caret(caret + emoji_txt.length)
    hidePopup(emoji_popup, emoji_btn)

  message_input.focus () ->
    hidePopup(emoji_popup, emoji_btn)


  message_form.submit (event) ->
    if $(this).find('.message_input').val().length == 0
      event.preventDefault()
      event.stopPropagation()

  message_form.bind 'ajax:success', (event, data) ->
    # reset the form
    this.reset()

  $('.review_mode').on 'ajax:success', (event, data) ->
    $("#message_#{data.message_id}").toggleClass('liked')

  if $('.message_form').length > 0
    channel.bind('chat_typing_event', (data) ->
      typingMsg = $('#typing_msg')
      if (data == 'typing')
        if typingMsg.length > 0
          typingMsg.css('visibility','visible')
        else
          $('<p>', {
            class: 'message'
            id: 'typing_msg'
          }).html('...').appendTo($("#messages"))
      else
        typingMsg.css('visibility','hidden')
    )

  $("#messages").bind "DOMSubtreeModified", ->
    $('#messages').animate({scrollTop: $('#messages').prop("scrollHeight")}, 500);

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

