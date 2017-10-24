//
//  MasterViewController.h
//  Jotable
//
//  Created by Keeton Feavel on 5/15/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <MessageUI/MessageUI.h>
#import "JotableModel+CoreDataModel.h"
#import "MessageDetailController.h"
#import "MessageSettingsController.h"
#import "MessageTableCell.h"
#import "AppDelegate.h"
#import "RMErrorPresentationController.h"
#import "RMColor.h"

@class DetailViewController;

@interface MessagesTableController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController<Message *> *fetchedResultsController;
@property (nonatomic) MessageDetailController *detailViewController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;


@end

