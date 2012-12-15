function updateTimerUI(value) {
  var w = Math.round(value * 120);
  if (w > 120) {
    w = 120;
  }
  $('.timer_container').find('.timer').css({ width: w + 'px' }).removeClass('hidden');
}

$( function () {

  var timer = K.Timer(10, 3);
  timer.start();

  timer.promise().progress( function (value) {
    updateTimerUI(value);
  });

  timer.promise().done( function (value) {
    updateTimerUI(value);
    console.log('finished');
  });
});
