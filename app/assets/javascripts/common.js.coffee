storageKey = 'knojoe:browser-notifications'

updateTitleCounter = (count) ->
  title = "(#{ count }) Knojoe" if count > 0
  document.title = title

sendNotification = (data) ->
  notification = window.webkitNotifications.createNotification('', 'Need your help', data.msg)
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
    sendNotification(data)
)

$ ->
  $("abbr.timeago").timeago()

  $("body").on("click", "a[disabled]", (event) ->
    event.preventDefault()
  )

  $("body").on("click",".alert .close", (event) ->
    event.preventDefault()
    event.stopPropagation()
    alert = $(this).parent('.alert')
    alert.remove()
    if window.localStorage
      key = alert.data('type')
      window.localStorage.setItem('knojoe:' + key,1) unless window.localStorage.getItem(key)
  )
