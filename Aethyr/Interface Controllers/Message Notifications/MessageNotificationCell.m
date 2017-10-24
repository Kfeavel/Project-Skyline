//
//  MessageNotificationCell.m
//  Aethyr
//
//  Created by Keeton Feavel on 6/27/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "MessageNotificationCell.h"

@interface MessageNotificationCell ()

// IBOutlets
#warning Move properties to .h for direct access
@property (weak, nonatomic) IBOutlet UILabel *messageContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageContactImage;

@end

@implementation MessageNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setters

- (void)setMessageContactLabelText:(NSString *)contact {
    self.messageContactLabel.text = contact;
}


- (void)setMessageContentLabelText:(NSString *)content {
    self.messageContentLabel.text = content;
}


- (void)setMessageContactImageContent:(UIImage *)image {
    self.messageContactImage.image = image;
}


@end
