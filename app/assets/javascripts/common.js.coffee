$ ->
  $("abbr.timeago").timeago()

  $("body").on("click", "a[disabled]", (event) ->
    event.preventDefault()
  )
