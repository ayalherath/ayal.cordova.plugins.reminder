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
         //NSMutableArray *remindersArray = [[NSMutableArray alloc] initWithArray:reminders];
         NSMutableArray *remindersArray = [[NSMutableArray alloc] init];
         for(int i=0; i<reminders.count; i++)
         {
             EKReminder *event = [reminders objectAtIndex:i];
             [remindersArray addObject:[NSString stringWithFormat:@"%@",event.title]];
         }
         CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsArray:remindersArray];
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



//-(NSMutableArray *)GetReminders
//{
//    eventStore = [[EKEventStore alloc] init];
//    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error)
//     {
//         //_remindersArray = [[NSMutableArray alloc] init];
//         // Create the predicate from the event store's instance method
//         NSPredicate *predicate = [eventStore predicateForRemindersInCalendars:nil];
//         NSMutableArray *remindersArray;
//         [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
//          {
//              NSMutableArray *remindersArray = [[NSMutableArray alloc] initWithArray:reminders];
//          }];
//     }];
//    return nil;
//}
//
//-(BOOL)AddEventReminder : (NSString *)reminderTitle
//{
//    EKReminder *reminder = [EKReminder reminderWithEventStore:eventStore];
//    [reminder setTitle:@"program test"];
//    EKCalendar *defaultReminderList = [eventStore defaultCalendarForNewReminders];
//    
//    [reminder setCalendar:defaultReminderList];
//    
//    NSError *error = nil;
//    BOOL success = [eventStore saveReminder:reminder
//                                     commit:YES
//                                      error:&error];
//    return nil;
//}


@end
