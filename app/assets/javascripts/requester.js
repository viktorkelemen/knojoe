function updateTimerUI(value) {
  // the value is between 0 and 1
  var h = Math.round(value * 25);
  if (h > 25) {
    h = 25;
  }
  $('.timer_container').find('.timer').css({ height: h + 'px' }).removeClass('hidden');
}

$( function () {
  if ($('.message_form').length > 1) {
    if (chatTimerOffset !== -1) {
      initTimer(chatTimerOffset);
    }
  }
});
