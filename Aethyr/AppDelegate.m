//
//  AppDelegate.m
//  Jotable
//
//  Created by Keeton Feavel on 5/15/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "AppDelegate.h"
#import "MessageDetailController.h"
#import "MessagesTableController.h"

@interface AppDelegate () <UISplitViewControllerDelegate, UNUserNotificationCenterDelegate,
                           MFMessageComposeViewControllerDelegate, NSFetchedResultsControllerDelegate,
                           UINavigationControllerDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
/* MFMessageComposeViewController */
@property (nonatomic) MFMessageComposeViewController *messageComposeController;
@property (nonatomic) Message *detailItem;
@property (nonatomic) id rootViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Set up CoreData with Magical Record
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    self.managedObjectContext = self.persistentContainer.viewContext;
    
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    UINavigationController *masterNavigationController = splitViewController.viewControllers[0];
    MessagesTableController *controller = (MessagesTableController *)masterNavigationController.topViewController;
    controller.managedObjectContext = self.persistentContainer.viewContext;
    
    // Customize app-wide navigation bar style
    [navigationController.navigationBar setTranslucent:NO];
    UINavigationBar *bar = [navigationController navigationBar];
    [bar setTintColor:[RMColor colorFromHexString:@"#e7eced"]];
    [bar setBarTintColor:[RMColor colorFromHexString:@"#202020"]];
    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [RMColor colorFromHexString:@"#202020"], NSForegroundColorAttributeName,
                                 nil]];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"Background...");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"Foreground...");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"Activating...");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - User Notifications

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"Notification!");
    if ([response.actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]) {
        // The user launched the app.
        NSLog(@"Launched from notification");
        if ([response.notification.request.content.categoryIdentifier isEqualToString:@"AETHYR_NOTIFICATION"]) {
            // Handle the actions for the expired timer.
            if ([response.actionIdentifier isEqualToString:@"SNOOZE_ACTION"])
            {
                // Invalidate the old timer and create a new one. . .
            }
            else if ([response.actionIdentifier isEqualToString:@"OTHER_ACTION"])
            {
                // Invalidate the timer. . .
#warning Add ability to snooze a notification (dismiss and copy uuid)
            }
            // ...
            for (Message *item in self.fetchedResultsController.fetchedObjects)
            {
                if ([item.identifier isEqualToString:response.notification.request.identifier]) {
                    self.detailItem = item;
                }
            }
            [self presentMessageComposer];
        }
    }
    // Else handle actions for other notification types. . .
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)presentMessageComposer {
    self.rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([self.rootViewController isKindOfClass:[UINavigationController class]])
    {
        self.rootViewController = ((UINavigationController *)self.rootViewController).viewControllers.firstObject;
    }
    if([self.rootViewController isKindOfClass:[UITabBarController class]])
    {
        self.rootViewController = ((UITabBarController *)self.rootViewController).selectedViewController;
    }
    if ([MFMessageComposeViewController canSendText])
    {
        self.messageComposeController = [[MFMessageComposeViewController alloc] init];
        [self.messageComposeController setDelegate:self];
        [self.messageComposeController setMessageComposeDelegate:self];
        [self.messageComposeController setBody:self.detailItem.content];
        [self.messageComposeController setRecipients:@[self.detailItem.number]];
        /*
         NSNumber *i = [NSNumber numberWithInteger:1];
         for (NSData *image in self.capturedImages) {
         NSLog(@"Inside loop");
         [self.messageComposeController addAttachmentData:image typeIdentifier:(NSString *)kUTTypePNG filename:[NSString stringWithFormat:@"Attachment%@.png",i]];
         i = [NSNumber numberWithInteger:[i integerValue] + 1];
         }
         */
        [self.rootViewController presentViewController:self.messageComposeController
                                              animated:YES
                                            completion:NULL];
    }
}
    
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: SMS sending failed");
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    
    [self.rootViewController dismissViewControllerAnimated:YES
                                                completion:NULL];
    self.messageComposeController = nil;
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[MessageDetailController class]] && ([(MessageDetailController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

- (NSFetchedResultsController<Message *> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Message *> *fetchRequest = Message.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController<Message *> *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                                        initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                        sectionNameKeyPath:nil
                                                                        cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        RMErrorPresentationController *alert = [[RMErrorPresentationController alloc] init];
        [alert presentErrorOnView:nil forError:error];
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"JotableModel"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
#warning Update error handling in persistent container and save context
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    RMErrorPresentationController *alert = [[RMErrorPresentationController alloc] init];
                    [alert presentErrorOnView:nil forError:error];
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        RMErrorPresentationController *alert = [[RMErrorPresentationController alloc] init];
        [alert presentErrorOnView:nil forError:error];
    }
}


@end
