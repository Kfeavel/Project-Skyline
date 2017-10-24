//
//  MessagesTableController.m
//  Jotable
//
//  Created by Keeton Feavel on 5/15/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "MessagesTableController.h"

@interface MessagesTableController ()
<UIViewControllerPreviewingDelegate>
// IBOutlet Properties
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationButtonEdit;

// Properties
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSData  *image;
@property (nonatomic) id previewingContext;

@end

@implementation MessagesTableController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [self configureView];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController Configuration

- (void)configureView {
    // Configure the ViewController programatically
#warning Update UIRefreshController to something more visually appealing
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [RMColor colorFromHexString:@"#202020"];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

- (void)toggleEdit {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing) {
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"check-circle"]];
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"trash"]];
    } else {
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"edit"]];
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"plus"]];
    }
}

#pragma mark - IBActions

- (IBAction)insertNewObject:(id)sender {
    // Define context
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    // Display picker
    if (self.tableView.editing) {
#warning Complete deleting multiple cells implementation
        NSLog(@"Find a way to delete multiple selected items");
    } else {
        Message *newEvent = [[Message alloc] initWithContext:context];
        newEvent.content = [NSString stringWithFormat:@"Tap to setup message."];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            RMErrorPresentationController *alert = [[RMErrorPresentationController alloc] init];
            [alert presentErrorOnView:self forError:error];
        }
    }
}

- (IBAction)showNotifications:(id)sender {
    [self performSegueWithIdentifier:@"showNotifications" sender:self];
}

- (IBAction)editTable:(id)sender {
    [self toggleEdit];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare appropriate views with data
    if ([[segue identifier] isEqualToString:@"showSetup"]) {
        // First time setup
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Message *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        MessageSettingsController *controller = (MessageSettingsController *)[segue destinationViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // Message already completed setup
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Message *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        MessageDetailController *controller = (MessageDetailController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[self.fetchedResultsController sections] count]) {
        return [[self.fetchedResultsController sections] count];
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 1;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"System" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (MessageTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Message *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withEvent:event];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            RMErrorPresentationController *alert = [[RMErrorPresentationController alloc] init];
            [alert presentErrorOnView:self forError:error];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (event.setup) {
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    } else {
        [self performSegueWithIdentifier:@"showSetup" sender:self];
    }
}

- (void)configureCell:(MessageTableCell *)cell withEvent:(Message *)event {
#warning Look at configureCell:(MessageTableCell *)cell withEvent:(Message *)event for bad cell bug.
    cell.messageContentLabel.text = event.content;
    cell.messageContactLabel.text = event.name;
    cell.messageContactImage.image = [UIImage imageWithData:event.image];
    // Set cell date based on Formatting
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    cell.messageTimeLabel.text = [formatter stringFromDate:event.fire];
}

- (void)refresh {
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    // Cache name specified in (NSFetchedResultsController<Message *> *)fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController<Message *> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Message *> *fetchRequest = Message.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController<Message *> *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                                        initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                        sectionNameKeyPath:nil
                                                                        cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.

#pragma mark - Peek and Pop
#warning Fix bug related to setup skipped with Peek/Pop
- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (UIViewController *)previewingContext:(id)previewingContext viewControllerForLocation:(CGPoint)location {
    // check if we're not already displaying a preview controller
    if ([self.presentedViewController isKindOfClass:[MessageDetailController class]]) {
        return nil;
    }
    
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPostion];
    
    if (path) {
        UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:path];
        
        // get your UIStoryboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // set the view controller by initializing it form the storyboard
        MessageDetailController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"MessageDetailController"];
        
        // if you want to transport date use your custom "detailItem" function like this:
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tableCell];
        Message *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        previewController.detailItem = object;
        
        return previewController;
    }
    return nil;
}

- (void)previewingContext:(id)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    // to render it with a navigation controller (more common) you should use this:
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self isForceTouchAvailable]) {
        if (!self.previewingContext) {
            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
        }
    } else {
        if (self.previewingContext) {
            [self unregisterForPreviewingWithContext:self.previewingContext];
            self.previewingContext = nil;
        }
    }
}

@end
