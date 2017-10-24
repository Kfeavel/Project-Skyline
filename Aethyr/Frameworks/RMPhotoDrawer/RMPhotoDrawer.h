//
//  RMPhotoDrawer.h
//  Aethyr
//
//  Created by Keeton Feavel on 7/3/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JotableModel+CoreDataModel.h"
#import "RMErrorPresentationController.h"
#import "RMPhotoDrawerCell.h"

@interface RMPhotoDrawer : UIViewController

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic) Message *detailItem;

@end
