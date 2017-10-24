//
//  RMAlert.h
//  Aethyr
//
//  Created by Keeton Feavel on 7/1/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RMAlert : NSObject

- (void)presentAlertOnView:(UIViewController *)view withTitle:(NSString *)title text:(NSString *)text andButton:(NSString *)button;

@end
