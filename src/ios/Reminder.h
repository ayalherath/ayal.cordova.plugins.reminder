//
//  Reminder.h
//  ReminderPlugin
//
//  Created by Ayal Herath on 1/21/15.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <EventKit/EventKit.h>


@interface Reminder : CDVPlugin

@property (nonatomic, retain) EKEventStore* eventStore;

- (void)initEventStoreWithReminderCapabilities;

- (void)addReminder:(CDVInvokedUrlCommand*)command;

- (void)getAllReminders:(CDVInvokedUrlCommand*)command;


@end
