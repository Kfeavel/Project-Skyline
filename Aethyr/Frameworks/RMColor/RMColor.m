//
//  RMColor.m
//  Aethyr
//
//  Created by Keeton Feavel on 6/26/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "RMColor.h"

@implementation RMColor

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:1.0];
}


- (void)addGradientBackgroundForView:(UIView *)view withTopColor:(UIColor *)top andBottom:(UIColor *)bottom {
    /*
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = colors;
    [view.layer insertSublayer:gradient atIndex:0];
    */
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    //gradient.startPoint = CGPointZero;
    //gradient.endPoint = CGPointMake(1, 1);
    gradient.colors = [NSArray arrayWithObjects:(id)top,(id)bottom, nil];
    [view.layer addSublayer:gradient];
}

@end
