//
//  MessageSettingsController.h
//  Aethyr
//
//  Created by Keeton Feavel on 6/25/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <UserNotifications/UserNotifications.h>
#import <pop/POP.h>
#import "MessageDetailController.h"
#import "JotableModel+CoreDataModel.h"
#import "RMErrorPresentationController.h"
#import "RMNotificationManager.h"

@interface MessageSettingsController : UIViewController

@property (nonatomic) Message *detailItem;

@end
