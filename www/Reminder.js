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

Reminder.prototype.deleteReminderByTitle = function (title, successCallback, errorCallback) {
   cordova.exec(successCallback, errorCallback, "Reminder", "deleteReminderByTitle", [{
    "reminderTitle": title
     }]);
};
               
Reminder.prototype.deleteReminderBycalendarItemIdentifier = function (calendarItemIdentifier, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, "Reminder", "deleteReminderByCalendarItemIdentifier", [{
     "calendarItemIdentifier": calendarItemIdentifier
     }]);
};
               
Reminder.prototype.markAsCompleated = function (calendarItemIdentifier, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, "Reminder", "markAsCompleated", [{
     "calendarItemIdentifier": calendarItemIdentifier
     }]);
};

Reminder.install = function () {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.Reminder = new Reminder();
  return window.plugins.Reminder;
};

cordova.addConstructor(Reminder.install);
