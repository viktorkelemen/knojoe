updateTitleCounter = (count) ->
  title = "(#{ count }) Knojoe" if count > 0
  document.title = title

$(document).on('ui-num-of-active-chat', (event, active_chats_count) ->
  updateTitleCounter(active_chats_count)
)

$(document).on('ui-new-question', (event, data) ->
  if window.webkitNotifications.checkPermission() == 0
    notification = window.webkitNotifications.createNotification('', 'Need your help', data.msg)
    notification.onclick = ->
      window.location = data.url

    notification.show()
)

$ ->
  $("abbr.timeago").timeago()

  $("body").on("click", "a[disabled]", (event) ->
    event.preventDefault()
  )
