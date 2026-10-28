// Meeting reminder hook: after the visitor has stayed on the page for
// more than 10 seconds, show a dialog about the IT project management meeting.
(function () {
  var DELAY_MS = 10000;
  var MESSAGE = 'Reminder: IT project management meeting next Wednesday at 10:00 AM in Room 123.';

  setTimeout(function () {
    alert(MESSAGE);
  }, DELAY_MS);
})();
