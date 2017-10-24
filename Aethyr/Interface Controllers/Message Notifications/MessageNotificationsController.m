//
//  MessageNotificationsController.m
//  Aethyr
//
//  Created by Keeton Feavel on 6/27/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "MessageNotificationsController.h"

@interface MessageNotificationsController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationButtonEdit;
@property (nonatomic) NSArray *notifications;

@end

@implementation MessageNotificationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.notifications = [[NSArray alloc] initWithArray:[self loadNotifications]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)editTable:(id)sender {
    [self toggleEdit];
}


- (IBAction)dismissView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notifications

- (NSArray *)loadNotifications {
    NSMutableArray *notes = [[NSMutableArray alloc] initWithArray:@[]];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        NSLog(@"Pending: %@",requests);
        for (id item in requests) {
            NSLog(@"%@",item);
            [notes addObject:item];
        }
    }];
    return [notes copy];
}

#pragma mark - Table view editing

- (void)toggleEdit {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing)
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"check-circle"]];
    else
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"edit"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notifications count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    // Set cell date based on Formatting
#warning Make sure to include the CoreData fire date information in the notification userinfo "fire","name","photo"
    UNNotificationRequest *request = [self.notifications objectAtIndex:indexPath.row];
    NSDictionary *info = [[request content] userInfo];
    NSDate *date = [info objectForKey:@"fire"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMM d, yyyy"];
    [cell setMessageContentLabelText:[NSString stringWithFormat:@"Scheduled for %@",[formatter stringFromDate:date]]];
    [cell setMessageContactLabelText:[NSString stringWithFormat:@"%@",[info objectForKey:@"name"]]];
    [cell setMessageContactImageContent:[UIImage imageWithData:[info objectForKey:@"photo"]]];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        UNNotificationRequest *request = [self.notifications objectAtIndex:indexPath.row];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removePendingNotificationRequestsWithIdentifiers:@[request.identifier]];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"NotificationsController shouldn't be preparing for segue...");
}

@end
