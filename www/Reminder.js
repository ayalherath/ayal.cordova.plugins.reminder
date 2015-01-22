"use strict";
function Reminder() {
}

Reminder.prototype.addReminder = function (title, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, "Reminder", "addReminder", [{
    "reminderTitle": title
    }]);
};

Reminder.prototype.getAllReminders = function (successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "Reminder", "getAllReminders");
};


Reminder.install = function () {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.Reminder = new Reminder();
  return window.plugins.Reminder;
};

cordova.addConstructor(Reminder.install);
