$ ->
  $('.message_form').bind 'ajax:success', (event, data) ->
    # reset the form
    this.reset()
