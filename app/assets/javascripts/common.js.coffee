storageKey = 'knojoe:browser-notifications'

updateTitleCounter = (count) ->
  title = "(#{ count }) Knojoe" if count > 0
  document.title = title

sendNotification = (msg) ->
  notification = window.webkitNotifications.createNotification('', 'Need your help', msg)
  notification.onclick = ->
    window.location = data.url

  notification.show()

$(document).on('ui-num-of-active-chat', (event, active_chats_count) ->
  updateTitleCounter(active_chats_count)
)

$(document).on('ui-new-question', (event, data) ->

  if (soundNotification = $('#notification_sound'))
    soundNotification[0].play()
  if window.localStorage && window.localStorage.getItem(storageKey) is 'on' &&
  window.webkitNotifications && window.webkitNotifications.checkPermission() == 0
    sendNotification(data.msg)
)

$ ->
  $("abbr.timeago").timeago()

  $("body").on("click", "a[disabled]", (event) ->
    event.preventDefault()
  )

  #Adding the socket_id to the form when a new chat created
  $("#new_chat").submit (event) ->
    if pusher?.connection?.socket_id?
      $(this).find('#socket_id').val(pusher.connection.socket_id)
