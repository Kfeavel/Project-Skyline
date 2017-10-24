//
//  RMKeyboardManager.m
//  Aethyr
//
//  Created by Keeton Feavel on 7/1/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "RMKeyboardManager.h"

@interface RMKeyboardManager ()

@property (nonatomic) UIViewController *view;

@end

@implementation RMKeyboardManager

- (instancetype)initWithView:(UIViewController *)controller {
    self = [super init];
    if (self) {
        // ...
    }
    return self;
}

- (void)addObserverToView:(UIViewController *)controller withObject:(_Nullable id)object {
    self.view = controller;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:object];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:object];
}

- (void)removeObserverFromViewWithObject:(_Nullable id)object {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.view = nil;
}

#pragma mark - UIKeyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.view.frame = f;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.view.frame;
        f.origin.y = 0.0f;
        self.view.view.frame = f;
    }];
}

@end
