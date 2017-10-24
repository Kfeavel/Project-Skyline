//
//  RMAlert.m
//  Aethyr
//
//  Created by Keeton Feavel on 7/1/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "RMAlert.h"

@implementation RMAlert

- (void)presentAlertOnView:(UIViewController *)view withTitle:(NSString *)title text:(NSString *)text andButton:(NSString *)button {
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:text
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:button
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    // Add action to alert
    [alert addAction:action];
    // Present alert on view
    [rootViewController presentViewController:alert
                                     animated:YES
                                   completion:^{
                                       //
                                   }];
}

@end
