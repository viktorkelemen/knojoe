updateTitleCounter = (count) ->
  title = "(#{ count }) Knojoe" if count > 0
  document.title = title

$(document).on('ui-num-of-active-chat', (event, active_chats_count) ->
  updateTitleCounter(active_chats_count)
)

$ ->
  $("abbr.timeago").timeago()

  $("body").on("click", "a[disabled]", (event) ->
    event.preventDefault()
  )
