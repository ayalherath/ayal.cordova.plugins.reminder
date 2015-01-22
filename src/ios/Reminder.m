//
//  Reminder.m
//  ReminderPlugin
//
//  Created by Ayal Herath on 1/21/15.
//
//

#import "Reminder.h"

@implementation Reminder

@synthesize eventStore;

#pragma mark Initialisation functions

- (CDVPlugin*) initWithWebView:(UIWebView*)theWebView {
    self = (Reminder*)[super initWithWebView:theWebView];
    if (self) {
        [self initEventStoreWithReminderCapabilities];
    }
    return self;
}

- (void)initEventStoreWithReminderCapabilities {
    __block BOOL accessGranted = NO;
    eventStore= [[EKEventStore alloc] init];
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        self.eventStore = eventStore;
    }
}


-(void)getAllReminders:(CDVInvokedUrlCommand*)command
{
    NSPredicate *predicate = [eventStore predicateForRemindersInCalendars:nil];
    [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
     {
         NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:reminders.count];
         
         NSDateFormatter *df = [[NSDateFormatter alloc] init];
         [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         
         for(int i=0; i<reminders.count; i++)
         {
             EKReminder *reminder = [reminders objectAtIndex:i];

             NSMutableDictionary *entry = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           reminder.title, @"title",
                                           reminder.calendarItemIdentifier, @"calendarItemIdentifier",
                                           [NSString stringWithFormat:@"%ld", (long)reminder.priority], @"priority",
                                           nil];
             if (reminder.completionDate != nil)
             {
                 [entry setObject:[df stringFromDate:reminder.completionDate] forKey:@"completionDate"];
             }
             
             if (reminder.creationDate != nil)
             {
                 [entry setObject:[df stringFromDate:reminder.creationDate] forKey:@"completionDate"];
             }
             
             if ([NSString stringWithFormat:@"%ld", (long)reminder.completed])
             {
                 [entry setObject:[NSString stringWithFormat:@"%ld", (long)reminder.completed] forKey:@"completed"];
             }
             
             [results addObject:entry];
         }
         CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsArray:results];
         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
     }];
}


- (void)addReminder:(CDVInvokedUrlCommand*)command
{
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString* reminderTitle      = [options objectForKey:@"reminderTitle"];
    EKReminder *reminder = [EKReminder reminderWithEventStore:eventStore];
    [reminder setTitle:reminderTitle];
    EKCalendar *defaultReminderList = [eventStore defaultCalendarForNewReminders];
    [reminder setCalendar:defaultReminderList];
    NSError *error = nil;
    BOOL success = [eventStore saveReminder:reminder
                                     commit:YES
                                      error:&error];
    if(success)
    {
        NSLog(@"Successfully added the reminder");
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    else
    {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error adding the reminder"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
}

-(void)deleteReminderByTitle:(CDVInvokedUrlCommand*)command
{
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString* reminderTitle = [options objectForKey:@"reminderTitle"];
    
    NSPredicate *predicate = [eventStore predicateForRemindersInCalendars:nil];
    [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
     {
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", reminderTitle];
         NSArray *results = [reminders filteredArrayUsingPredicate:predicate];
         
         for(int i=0;i<results.count;i++)
         {
             NSError *error = nil;
             [self.eventStore removeReminder:[results objectAtIndex:i] commit:YES error:&error];
         }
         
         NSLog(@"Successfully deleted the reminders");
         CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
     }];
}

-(void)deleteReminderByCalendarItemIdentifier:(CDVInvokedUrlCommand*)command
{
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString* reminderTitle = [options objectForKey:@"calendarItemIdentifier"];
    
    NSPredicate *predicate = [eventStore predicateForRemindersInCalendars:nil];
    [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
     {
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"calendarItemIdentifier matches %@", reminderTitle];
         NSArray *results = [reminders filteredArrayUsingPredicate:predicate];
         
         for(int i=0;i<results.count;i++)
         {
             NSError *error = nil;
             [self.eventStore removeReminder:[results objectAtIndex:i] commit:YES error:&error];
         }
         
         NSLog(@"Successfully deleted the reminder");
         CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
     }];
}

-(void) markAsCompleated:(CDVInvokedUrlCommand*)command
{
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString* calendarItemIdentifier = [options objectForKey:@"calendarItemIdentifier"];
    
    NSPredicate *predicate = [eventStore predicateForRemindersInCalendars:nil];
    [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
     {
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"calendarItemIdentifier matches %@", calendarItemIdentifier];
         NSArray *results = [reminders filteredArrayUsingPredicate:predicate];
         
         for(int i=0;i<results.count;i++)
         {
             EKReminder *reminder = [results objectAtIndex:i];
             reminder.completed = 1;
             NSError *error = nil;
             [self.eventStore removeReminder:reminder commit:YES error:&error];
         }
         
         NSLog(@"Successfully Compleated the reminder");
         CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
     }];
}

@end
