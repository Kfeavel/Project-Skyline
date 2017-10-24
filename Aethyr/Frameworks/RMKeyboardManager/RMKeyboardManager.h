//
//  RMKeyboardManager.h
//  Aethyr
//
//  Created by Keeton Feavel on 7/1/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RMKeyboardManager : NSObject

- (_Nullable instancetype)initWithView:(UIViewController * _Nonnull)controller;
- (void)addObserverToView:(UIViewController * _Nonnull)controller withObject:(_Nullable id)object;
- (void)removeObserverFromViewWithObject:(_Nullable id)object;

@end
