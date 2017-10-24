//
//  AppDelegate.h
//  Jotable
//
//  Created by Keeton Feavel on 5/15/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>
#import <MessageUI/MessageUI.h>
#import "JotableModel+CoreDataModel.h"
#import "RMColor.h"
#import "RMErrorPresentationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) NSFetchedResultsController<Message *> *fetchedResultsController;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

