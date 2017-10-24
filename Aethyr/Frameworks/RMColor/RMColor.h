//
//  RMColor.h
//  Aethyr
//
//  Created by Keeton Feavel on 6/26/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMColor : UIColor

+ (UIColor *)colorFromHexString:(NSString *)hexString;
- (void)addGradientBackgroundForView:(UIView *)view withTopColor:(UIColor *)top andBottom:(UIColor *)bottom;

@end
