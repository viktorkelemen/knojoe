(() ->
  storageKey = 'knojoe:browser-notifications'

  initNotificationButton = () ->

    btn = $('#notifications')

    if window.webkitNotifications.checkPermission() != 0
      window.localStorage.removeItem(storageKey)

    if val = window.localStorage.getItem(storageKey)
      if val == 'on'
        btn.prop('checked', true)
      else
        btn.prop('checked', false)

    btn.change (e) ->
      if btn.prop('checked')
        window.webkitNotifications.requestPermission()
        window.localStorage.setItem(storageKey,'on')
      else
        window.localStorage.removeItem(storageKey)


  $( () ->
    initNotificationButton() if window.webkitNotifications && window.localStorage

    document.cookie = "time_zone=#{ jstz.determine().name() };";

    #Adding the socket_id to the form when a new chat created
    $("#new_chat").submit (event) ->
      if pusher?.connection?.socket_id?
        $(this).find('#socket_id').val(pusher.connection.socket_id)
  )
)()
