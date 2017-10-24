//
//  MessageTableCell.h
//  Jotable
//
//  Created by Keeton Feavel on 5/17/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableCell : UITableViewCell

#pragma mark - Setters

@property (weak, nonatomic) IBOutlet UILabel *messageContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageContactImage;

@end
