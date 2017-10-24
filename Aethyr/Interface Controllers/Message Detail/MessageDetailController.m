//
//  DetailViewController.m
//  Jotable
//
//  Created by Keeton Feavel on 5/15/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "MessageDetailController.h"

@interface MessageDetailController ()
<UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate,
UINavigationControllerDelegate,CAAnimationDelegate,LHSKeyboardAdjusting,
UITableViewDelegate, UITableViewDataSource>

/* IBOutlets - Interface */
@property (weak, nonatomic) IBOutlet UITextView         *messageContentTextField;
@property (weak, nonatomic) IBOutlet UIView             *messageView;
@property (weak, nonatomic) IBOutlet UILabel            *messageRecipientLabel;
@property (weak, nonatomic) IBOutlet UILabel            *messageNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *messageRecipientContactImage;
/* IBOutlets - Navigation */
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *navigationShareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *navigationSettingsButton;
@property (weak, nonatomic) IBOutlet UIButton           *buttonPresentDatePicker;
/* IBOutlets - Toolbar */
@property (weak, nonatomic) IBOutlet UIToolbar          *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *navigationAddButton;
@property (weak, nonatomic) IBOutlet UIView             *navigationMessageView;
@property (weak, nonatomic) IBOutlet UITextView         *navigationMessageTextView;
/* IBOutlets - NSLayoutConstrain */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarLeadingConstrain;
/* IBOutlets - TableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* Properties */
@property (nonatomic) RMKeyboardManager                 *keyboard;
@property (nonatomic) UIImagePickerController           *imagePickerController;
@property (nonatomic) CGRect                             previousRect;
@property (nonatomic) RMPhotoDrawer                     *drawer;

/* MFMessageComposeViewController */
@property (nonatomic) MFMessageComposeViewController    *messageComposeController;
@property bool isPhotoDrawerShowing;

@end

@implementation MessageDetailController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [self configureView];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self lhs_activateKeyboardAdjustment];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveData];
    [self lhs_deactivateKeyboardAdjustment];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController Configuration

- (void)configureView {
    RMColor *color = [[RMColor alloc] init];
    [color addGradientBackgroundForView:self.messageView withTopColor:[RMColor colorFromHexString:@"#5eaff3"]
                              andBottom:[RMColor colorFromHexString:@"#3782f0"]];
    //5eaff3 for first, 3782f0 for second
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationMessageTextView.delegate = self;
    
    // Remove config view from "Back" button
    NSArray *nav = [self.navigationController.navigationController viewControllers];
    NSLog(@"Stack: %@",nav);
    for (UIViewController *v in nav)
    {
        if ([v isKindOfClass:[MessageSettingsController class]])
        {
            [v removeFromParentViewController];
        }
    }
    
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.navigationMessageTextView.text = self.detailItem.content;
    self.navigationMessageTextView.delegate = self;
    
    self.messageContentTextField.text = self.navigationMessageTextView.text;
    self.messageRecipientLabel.text = self.detailItem.name;
    self.messageNumberLabel.text = self.detailItem.number;
    self.messageRecipientContactImage.image = [UIImage imageWithData:self.detailItem.image];
    self.isPhotoDrawerShowing = false;
    
    // Create tap gesture to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    //
}

#pragma mark - IBActions

- (IBAction)navigationButtonAddPhotoSelection:(id)sender {
    [self preparePhotoDrawer];
}


- (IBAction)navigationButtonShowSetup:(id)sender {
    [self performSegueWithIdentifier:@"showSetup" sender:self];
}


- (IBAction)toolbarDismissKeyboard:(id)sender {
    [self saveData];
    [self dismissKeyboard];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self saveData];
    [self dismissKeyboard];
    if ([[segue identifier] isEqualToString:@"showSetup"]) {
        // First time setup
        MessageSettingsController *controller = (MessageSettingsController *)[segue destinationViewController];
        [controller setDetailItem:self.detailItem];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    NSStringDrawingContext *ctx = [NSStringDrawingContext new];
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:self.navigationMessageTextView.text];
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:aString];
    CGRect textRect = [calculationView.text boundingRectWithSize:self.view.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:calculationView.font} context:ctx];
    return textRect.size.height;
    */
    return 100;
}


- (MessageDetailCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    cell.detailText.text = self.navigationMessageTextView.text;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - LHSKeyboardAdjusting

- (BOOL)keyboardAdjustingAnimated {
    return YES;
}


- (UIView *)keyboardAdjustingView {
    return self.toolbar;
}

#pragma mark - Photo Drawer

- (void)preparePhotoDrawer {
    NSLog(@"1. isDrawerShowing? %i",self.isPhotoDrawerShowing);
    self.drawer = [self.storyboard instantiateViewControllerWithIdentifier:@"RMPhotoDrawer"];
    self.drawer.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.drawer.detailItem = self.detailItem;
    // x = 0, y = 200 from bottom, size = screen width, height = 200
    CGRect frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
    self.drawer.view.frame = frame;
    if (self.isPhotoDrawerShowing) {
        // Dismiss drawer and move view back
        [self dismissPhotoDrawer:self.drawer];
    } else {
        // Present drawer and move view
        [self presentPhotoDrawer:self.drawer];
    }
    NSLog(@"2. isDrawerShowing? %i",self.isPhotoDrawerShowing);
}


- (void)presentPhotoDrawer:(RMPhotoDrawer *)drawer {
    NSLog(@"Presenting drawer");
    //[self addChildViewController:self.drawer];
    //[self.view addSubview:self.drawer.view];
    [self.navigationMessageTextView setInputView:drawer.view];
    [self.navigationMessageTextView becomeFirstResponder];
    self.isPhotoDrawerShowing = true;
    NSLog(@"isDrawerShowing? %i",self.isPhotoDrawerShowing);
}


- (void)dismissPhotoDrawer:(RMPhotoDrawer *)drawer {
    NSLog(@"Dismissing drawer");
    [self.navigationMessageTextView resignFirstResponder];
    [self.navigationMessageTextView setInputView:nil];
    self.isPhotoDrawerShowing = false;
    NSLog(@"isDrawerShowing? %i",self.isPhotoDrawerShowing);
}

#pragma mark - CoreData

- (void)updateData __deprecated {
    // If appropriate, configure the new managed object.
    NSManagedObjectContext *context = self.detailItem.managedObjectContext;
    
    self.detailItem.content = _messageContentTextField.text;
#warning Replace NSKeyedArchiver method of image saving with array of png file paths using NSFileManager
//    self.detailItem.photo = [NSKeyedArchiver archivedDataWithRootObject:self.capturedImages];
//    [self.capturedImages removeAllObjects];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        RMErrorPresentationController *view = [[RMErrorPresentationController alloc] init];
        [view presentErrorOnView:self forError:error];
    }
}


- (void)saveData {
    NSManagedObjectContext *context = self.detailItem.managedObjectContext;
    // Copy information to message
    self.detailItem.content = self.navigationMessageTextView.text;
    // Save context
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        RMErrorPresentationController *alert = [[RMErrorPresentationController alloc] init];
        [alert presentErrorOnView:self forError:error];
    }
}

#pragma mark - UITextView Delegate

- (void)dismissKeyboard {
    NSLog(@"Dismiss keyboard called");
    [self.navigationMessageTextView resignFirstResponder];
    if (self.isPhotoDrawerShowing) {
        [self dismissPhotoDrawer:self.drawer];
    }
    NSLog(@"isDrawerShowing? (Dismiss) %i",self.isPhotoDrawerShowing);
}


- (void)textViewDidChange:(id)sender {
    // Timestamp used for sorting based on most-recently edited message
    //NSLog(@"Sender: %@",sender);
    if (sender == self.navigationMessageTextView) {
        self.messageContentTextField.text = self.navigationMessageTextView.text;
        [self.tableView reloadData];
    }
    self.detailItem.timestamp = [NSDate date];
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.navigationMessageTextView.text isEqualToString:@"Message"] || [self.navigationMessageTextView.text isEqualToString:@"Tap to setup message."]) {
        self.navigationMessageTextView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

@end
