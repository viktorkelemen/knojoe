function updateTimerUI(value) {
  var w = Math.round(value * 120);
  if (w > 120) {
    w = 120;
  }
  $('.timer_container').find('.timer').css({ width: w + 'px' }).removeClass('hidden');
}

$( function () {
  if ($('.message_form').length > 1) {
    if (chatTimerOffset !== -1) {
      initTimer(chatTimerOffset);
    }
  }
});
