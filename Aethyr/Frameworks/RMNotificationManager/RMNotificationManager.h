//
//  RMNotificationManager.h
//  Aethyr
//
//  Created by Keeton Feavel on 7/1/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import "JotableModel+CoreDataModel.h"
#import "RMAlert.h"
#import "RMErrorPresentationController.h"

@interface RMNotificationManager : NSObject

- (nonnull instancetype)initWithMessage:(nonnull Message *)info;
- (void)registerNotificationWithTitle:(nonnull NSString *)title body:(nonnull NSString *)body andSound:(nonnull UNNotificationSound *)sound;

@end
