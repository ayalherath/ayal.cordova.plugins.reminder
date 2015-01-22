# Cordova Reminder plugin 

for iOS , by [Ayal Herath](ayalherath@gmail.com)


## 1. Description

This plugin allows you to add reminders and get reminders of iOS mobile device.

* Works with PhoneGap >= 3.0.
* Compatible with [Cordova Plugman](https://github.com/apache/cordova-plugman).


### iOS specifics
* Supported methods: `find`, `create`, `delete`, `update`, ....
* Tested on iOS 8.

## 2. Installation

### Automatically (CLI / Plugman)
Reminder is compatible with [Cordova Plugman](https://github.com/apache/cordova-plugman) and ready for the [PhoneGap 3.0 CLI](http://docs.phonegap.com/en/3.0.0/guide_cli_index.md.html#The%20Command-line%20Interface_add_features), here's how it works with the CLI:

```
$ cordova plugin add https://github.com/ayalherath/ayal.cordova.plugins.reminder.git
```
and run this command afterwards:
```
$ cordova build
```

### Manually

#### iOS

1\. Add the following xml to your `config.xml`:
```xml
<!-- for iOS -->
<feature name="Reminder">
	<param name="ios-package" value="Reminder" />
</feature>
```

2\. Grab a copy of Reminder.js, add it to your project and reference it in `index.html`:
```html
<script type="text/javascript" src="js/Reminder.js"></script>
```

3\. Download the source files for iOS and copy them to your project.

Copy `Reminder.h` and `Reminder.m` to `platforms/ios/<ProjectName>/Plugins`

4\. Click your project in XCode, Build Phases, Link Binary With Libraries, search for and add `EventKit.framework` and `EventKitUI.framework`.


## 3. Usage

Basic operations, you'll want to copy-paste this for testing purposes:

```javascript
  
 window.plugins.Reminder.getAllReminders(success,error);

 window.plugins.Reminder.addReminder(title,success,error);

 window.plugins.Reminder.deleteReminderByTitle(title,success,error);

 window.plugins.Reminder.deleteReminderByCalendarItemIdentifier(calendarItemIdentifier,success,error);
 
 window.plugins.Reminder.markAsCompleated(calendarItemIdentifier,success,error);
 
 window.plugins.Reminder.markAsPending(calendarItemIdentifier,success,error);

```

## 4. CREDITS ##


* Credits for the https://github.com/EddyVerbruggen/Calendar-PhoneGap-Plugin.
  I got the idea to write the plug-in by looking at above plugin.


## 5. License

[The MIT License (MIT)](http://www.opensource.org/licenses/mit-license.html)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
