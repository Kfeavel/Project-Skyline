//
//  MessageNotificationCell.h
//  Aethyr
//
//  Created by Keeton Feavel on 6/27/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNotificationCell : UITableViewCell

#pragma mark - Setters

- (void)setMessageContactLabelText:(NSString *)contact;
- (void)setMessageContentLabelText:(NSString *)content;
- (void)setMessageContactImageContent:(UIImage *)image;


@end
