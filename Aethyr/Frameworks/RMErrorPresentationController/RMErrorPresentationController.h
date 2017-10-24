//
//  RMErrorPresentationController.h
//  Jotable
//
//  Created by Keeton Feavel on 5/22/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface RMErrorPresentationController : NSObject

- (void)presentErrorOnView:(nullable UIViewController *)view forError:(nonnull NSError *)error;

@end
