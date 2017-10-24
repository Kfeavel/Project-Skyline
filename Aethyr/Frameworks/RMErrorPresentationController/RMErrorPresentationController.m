//
//  RMErrorPresentationController.m
//  Jotable
//
//  Created by Keeton Feavel on 5/22/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "RMErrorPresentationController.h"

@interface RMErrorPresentationController ()

@property (nonatomic) UIViewController *controller;
@property (nonatomic) NSError *controllerError;

@end

@implementation RMErrorPresentationController

- (void)presentErrorOnView:(nullable UIViewController *)view forError:(nonnull NSError *)error {
    [self presentAlertOnView:view forError:error];
}


- (void)presentAlertOnView:(UIViewController *)view forError:(NSError *)error {
    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    // Present an alert
    id rootViewController;
    // Check if no view is provided (i.e. in an NSObject subclass)
    if (view == nil) {
        rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if([rootViewController isKindOfClass:[UINavigationController class]])
        {
            rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
        }
        if([rootViewController isKindOfClass:[UITabBarController class]])
        {
            rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
        }
    } else {
        rootViewController = view;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:[NSString stringWithFormat:@"%@",error.description]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Continue (unstable)"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       NSLog(@"Continuing in an unstable state...");
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    UIAlertAction *crash = [UIAlertAction actionWithTitle:@"Crash (safer)"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                       NSLog(@"Crashing...");
                                                       abort();
                                                   }];
    // Add action to alert
    [alert addAction:action];
    [alert addAction:crash];
    // Present alert on view
    [rootViewController presentViewController:alert
                                     animated:YES
                                   completion:^{
                                       //
                                   }];
}

@end
