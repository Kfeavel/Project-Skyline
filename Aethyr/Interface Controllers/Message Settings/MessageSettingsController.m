//
//  MessageSettingsController.m
//  Aethyr
//
//  Created by Keeton Feavel on 6/25/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "MessageSettingsController.h"
#import "GMYConfettiView.h"

@interface MessageSettingsController () <
    UIPickerViewDelegate,
    UITextFieldDelegate,
    CNContactPickerDelegate
>
// IBOutlet Properties
@property (weak, nonatomic) IBOutlet UILabel        *instructionsHeader;
@property (weak, nonatomic) IBOutlet UILabel        *instructionsLabel1;
@property (weak, nonatomic) IBOutlet UILabel        *instructionsLabel2;
@property (weak, nonatomic) IBOutlet UILabel        *instructionsLabel3;
@property (weak, nonatomic) IBOutlet UITextField    *dateField;
@property (weak, nonatomic) IBOutlet UIImageView    *messageRecipientButton;
@property (weak, nonatomic) IBOutlet UILabel        *messageRecipientName;
@property (weak, nonatomic) IBOutlet UILabel        *messageRecipientPhone;
@property (weak, nonatomic) IBOutlet UIButton       *viewDismissButton;
// Non-IBOutlet Properties
@property (nonatomic) UIDatePicker                  *messageDatePicker;
@property (nonatomic) NSString                      *name;
@property (nonatomic) NSString                      *phone;
@property (nonatomic) NSData                        *image;
@property (nonatomic) CNContactPickerViewController *contactPicker;
@property (nonatomic) IBOutlet GMYConfettiView *confettiView;

@end

@implementation MessageSettingsController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showMessage"]) {
        Message *object = self.detailItem;
        MessageDetailController *controller = (MessageDetailController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - UIViewController Configuration

- (void)configureView {
    // Check for pre-existing configuration
    if (self.detailItem.image) {
        self.messageRecipientButton.image = [UIImage imageWithData:self.detailItem.image];
    }
    if (self.detailItem.name) {
        self.messageRecipientName.text = self.detailItem.name;
    }
    if (self.detailItem.number) {
        self.messageRecipientPhone.text = self.detailItem.number;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    [self.dateField setText:[formatter stringFromDate:self.detailItem.fire]];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self.dateField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self.dateField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self configureDateFieldInputView];
    
    self.confettiView = [[GMYConfettiView alloc] initWithFrame:self.confettiView.frame];
    [self.confettiView setSpriteType:Confetti];
#warning Fix completion code and all other various animation based crap
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageRecipientButtonSelected)];
    [singleTap setNumberOfTapsRequired:1];
    //[self.messageRecipientButton addGestureRecognizer:singleTap];
    // Create POP animations
    POPSpringAnimation *header = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    header.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    header.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
    header.springBounciness = 20.f;
    [self.instructionsHeader pop_addAnimation:header forKey:@"springAnimation1"];
    header.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        // Animation complete
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer *timer) {
            POPSpringAnimation *header2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            header2.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
            header2.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
            header2.springBounciness = 20.f;
            [self.instructionsLabel1 pop_addAnimation:header2 forKey:@"springAnimation2"];
            [self.instructionsLabel1 setHidden:NO];
            header2.completionBlock = ^(POPAnimation *anim, BOOL finished)
            {
                // Animation complete
                [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer *timer) {
                    POPSpringAnimation *header2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                    header2.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
                    header2.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
                    header2.springBounciness = 20.f;
                    
                    [self.messageRecipientButton pop_addAnimation:header2 forKey:@"springAnimation"];
                    [self.messageRecipientName pop_addAnimation:header2 forKey:@"springAnimation"];
                    [self.messageRecipientPhone pop_addAnimation:header2 forKey:@"springAnimation"];
                    
                    self.messageRecipientButton.hidden = NO;
                    self.messageRecipientName.hidden = NO;
                    self.messageRecipientPhone.hidden = NO;
                    [self.messageRecipientButton addGestureRecognizer:singleTap];
#warning Replace tap to dismiss with UIAccessoryView with "Done" button
                }];
            };
        }];
    };
}


- (void)messageRecipientButtonSelected {
    self.contactPicker = [[CNContactPickerViewController alloc] init];
    self.contactPicker.delegate = self;
    [self presentViewController:self.contactPicker
                       animated:YES
                     completion:^{
                         // Finished Selecting Contact
                         // Use POP Framework to make the rest of the view visible piece by piece
                         POPSpringAnimation *header3 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                         header3.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
                         header3.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
                         header3.springBounciness = 20.f;
                         [self.instructionsLabel2 pop_addAnimation:header3 forKey:@"springAnimation3"];
                         [self.instructionsLabel2 setHidden:NO];
                         header3.completionBlock = ^(POPAnimation *anim, BOOL finished)
                         {
                             // Animation complete
                             [self.dateField setHidden:NO];
                             [self.dateField setEnabled:YES];
                         };
                     }];
}

#pragma mark - IBAction

- (IBAction)viewDismissButtonSelected:(id)sender {
    // Register notification
    RMNotificationManager *notif = [[RMNotificationManager alloc] initWithMessage:self.detailItem];
    [notif registerNotificationWithTitle:[NSString stringWithFormat:@"Time to send your message to %@!",self.detailItem.name]
                                    body:self.detailItem.content
                                   andSound:[UNNotificationSound soundNamed:@"vineshroom.caf"]];
    // Note: Due to notifications using a UUID system, we never need to replace or change the contents of the notification
    // Because when the MFMessageComposeView is triggered in AppDelegate, the Message database is cycled-through
    // until the corresponding message.identifier is found. This allows for dynamic loading of information. However, rich
    // notification actions need to be added in order to snooze or cancel the message.
    // Complete transaction and dismiss
    if (self.detailItem.setup == FALSE) {
        self.detailItem.setup = TRUE;
        [self.confettiView stopConfetti];
        [self performSegueWithIdentifier:@"showMessage" sender:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Fetching contacts

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    [self getContactDetails:contact];
}

/*
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNContact *contact = contactProperty.contact;
    NSString *identify = contactProperty.identifier;
    for (CNLabeledValue<CNPhoneNumber*>* number in contact.phoneNumbers) {
        if ([number.identifier isEqualToString:identify]) {
            _phone = ((CNPhoneNumber *)number.value).stringValue;
        }
    }
    _name = [NSString stringWithFormat:@"%@ %@",contact.givenName, contact.familyName];
    _image = contact.imageData;
    
    self.messageRecipientName.text = _name;
    self.messageRecipientName.text = _phone;
    self.messageRecipientButton.imageView.image = [UIImage imageWithData:_image];
    
}
*/

- (void)getContactDetails:(CNContact *)contactObject {
#warning Clean up this mess of code
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",contactObject.givenName,contactObject.familyName];
    self.name = fullName;
    NSData *imageData = [[NSData alloc] init];
    if (contactObject.imageData) {
        imageData = contactObject.imageData;
        self.image = imageData;
    } else {
        imageData = UIImagePNGRepresentation([UIImage imageNamed:@"settings-profile"]);
        self.image = imageData;
    }
    
    NSString *phone = @"";
    NSString *userPHONE_NO = @"";
    for (CNLabeledValue *phonelabel in contactObject.phoneNumbers) {
        CNPhoneNumber *phoneNo = phonelabel.value;
        phone = [phoneNo stringValue];
        if (phone) {
            userPHONE_NO = phone;
        }}
    
    self.phone = userPHONE_NO;
    // Make things visible for the user
    self.messageRecipientName.text = fullName;
    self.messageRecipientPhone.text = phone;
    [self.messageRecipientButton setImage:[[UIImage alloc] initWithData:imageData]];
    // Set Message item properties
    self.detailItem.name = fullName;
    self.detailItem.number = phone;
    self.detailItem.image = imageData;
}


- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    NSLog(@"User canceled picker");
}

#pragma mark - UIKeyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    // Assume the user is done editing. Present confetti!
    [self.confettiView startConfetti];
    // Present POP animation
    POPSpringAnimation *header4 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    header4.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    header4.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
    header4.springBounciness = 20.f;
    [self.instructionsLabel3 pop_addAnimation:header4 forKey:@"springAnimation3"];
    [self.instructionsLabel3 setHidden:NO];
    header4.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        // Animation complete
        [self.viewDismissButton setHidden:NO];
        [self.viewDismissButton setEnabled:YES];
    };
}

#pragma mark - UIDatePicker

- (void)configureDateFieldInputView {
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self
                   action:@selector(dateUpdated:)
         forControlEvents:UIControlEventValueChanged];
    self.dateField.inputView = datePicker;
    self.dateField.delegate = self;
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(dismissKeyboard)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    self.dateField.inputAccessoryView = keyboardToolbar;
}


- (void)dateUpdated:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    self.dateField.text = [formatter stringFromDate:datePicker.date];
    self.detailItem.fire = datePicker.date;
}

@end
