//
//  DetailViewController.h
//  Jotable
//
//  Created by Keeton Feavel on 5/15/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <MessageUI/MessageUI.h>
#import <UserNotifications/UserNotifications.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <LHSKeyboardAdjusting/LHSKeyboardAdjusting.h>
#import <LHSKeyboardAdjusting/UIViewController+LHSKeyboardAdjustment.h>
#import "JotableModel+CoreDataModel.h"
#import "MessageSettingsController.h"
#import "MessageDetailCell.h"
#import "RMErrorPresentationController.h"
#import "RMColor.h"
#import "RMKeyboardManager.h"
#import "RMPhotoDrawer.h"

@interface MessageDetailController : UIViewController

@property (strong, nonatomic) Message *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) NSLayoutConstraint *keyboardAdjustingBottomConstraint;

@end

