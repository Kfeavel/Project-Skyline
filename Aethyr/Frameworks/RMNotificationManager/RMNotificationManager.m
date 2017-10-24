//
//  RMNotificationManager.m
//  Aethyr
//
//  Created by Keeton Feavel on 7/1/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "RMNotificationManager.h"

@interface RMNotificationManager ()

@property (nonatomic) Message *detailItem;

@end

@implementation RMNotificationManager

- (instancetype)initWithMessage:(Message *)info {
    self = [super init];
    if (self) {
        self.detailItem = info;
        [self requestNotificationPermissions];
    }
    //self.detailItem = info;
    return self;
}

#pragma mark - UserNotification

- (void)requestNotificationPermissions {
    // Initialize UserNotification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge;
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError *error) {
                              if (!granted) {
                                  NSLog(@"An undefined error orruced.");
                              }
                          }];
    // Request Access for Notifications
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
            RMAlert *alert = [[RMAlert alloc] init];
            [alert presentAlertOnView:nil
                            withTitle:@"Permissions"
                                 text:@"Aethyr must have access to notifications in order to work properly."
                            andButton:@"Dismiss"];
            NSLog(@"Notifications must be enabled for Aethyr to work.");
        }
    }];
}

/*
- (NSDictionary *)configureNotificationInfo {
    // Note: we no longer need to write this information to userInfo since we have the UUID system now
    Message *i = self.detailItem;
    NSDictionary *info = [[NSDictionary alloc] initWithObjects:@[i.number,
                                                                 i.content,
                                                                 i.photo]
                                                       forKeys:@[@"number",
                                                                 @"content",
                                                                 @"photo"]];
    return info;
}
*/

- (void)registerNotificationWithTitle:(nonnull NSString *)title body:(nonnull NSString *)body andSound:(nonnull UNNotificationSound *)sound {
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    RMErrorPresentationController *alert = [[RMErrorPresentationController alloc] init];
    
    // Customize notification contents
    content.title = title;
    content.body = body;
    if (sound) {
        content.sound = sound;
    }
    content.categoryIdentifier = @"AETHYR_NOTIFICATION";
    
    // Set UNCalendarNotificationTrigger date
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear  |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay   |
                                                         NSCalendarUnitHour  |
                                                         NSCalendarUnitMinute)
                                               fromDate:self.detailItem.fire];
    NSDateComponents *date = [[NSDateComponents alloc] init];
    date.year = [components year];
    date.month = [components month];
    date.day = [components day];
    date.hour = [components hour];
    date.minute = [components minute];
    
    // Create triggers based on date information
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:date
                                                                                                      repeats:NO];
    //UNTimeIntervalNotificationTrigger* debug = [UNTimeIntervalNotificationTrigger
    //                                              triggerWithTimeInterval:5 repeats:NO];
    
    // Create notification UUID and save it to the message
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSManagedObjectContext *context = self.detailItem.managedObjectContext;
    self.detailItem.identifier = uuid;
    
    // Save message context because of UUID assignment
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        [alert presentErrorOnView:nil forError:error];
    }
#warning Remove debug trigger before production
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:self.detailItem.identifier
                                                                          content:content
                                                                          trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            [alert presentErrorOnView:nil forError:error];
        }
    }];
}

@end
