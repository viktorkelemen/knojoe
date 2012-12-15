var K = K || {};

K.Timer = function (offset, limit, increment) {

  limit = limit || 60; // for how long (sec)
  increment = increment || 1; // for how often (sec)

  var counter = 0;
  var timer_id;

  var df;

  function start() {

    stop();

    df = $.Deferred();

    counter = offset / limit * increment;

    df.notify(counter);
    counter += 1 / limit * increment;

    timer_id = setInterval( function () {
      if (counter < 1) {
        df.notify(counter);
        counter += 1 / limit * increment;
      } else {
        df.resolve(counter);
        stop();
      }
    }, 1000 * increment);
  }

  function stop() {
    if (df) {
      df.reject();
    }
    if (timer_id !== undefined) {
      clearInterval(timer_id);
    }
  }

  return {
    start: start,
    stop: stop,
    promise: function () { return df.promise(); },
  }
};
