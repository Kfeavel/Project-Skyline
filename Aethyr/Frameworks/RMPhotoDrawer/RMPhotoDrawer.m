//
//  RMPhotoDrawer.m
//  Aethyr
//
//  Created by Keeton Feavel on 7/3/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "RMPhotoDrawer.h"

@interface RMPhotoDrawer ()
<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView             *sourceDrawer;
@property (weak, nonatomic) IBOutlet UICollectionView   *collection;
@property (weak, nonatomic) IBOutlet UIButton           *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton           *libraryButton;
@property (nonatomic) UIImagePickerController           *imagePickerController;

@property (nonatomic) NSMutableArray<UIImage *> *photos;

@end

@implementation RMPhotoDrawer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.photos = [[NSMutableArray alloc] init];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (UIView *)inputAccessoryView {
    return self.toolbar;
}

- (void)configureView {
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self becomeFirstResponder];
}

#pragma mark - IBActions

- (IBAction)cameraButtonTouchUp:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)libraryButtonTouchUp:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - CoreData

- (void)saveData {
    NSManagedObjectContext *context = self.detailItem.managedObjectContext;
    // Copy information to message
    
    // Save context
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        RMErrorPresentationController *alert = [[RMErrorPresentationController alloc] init];
        [alert presentErrorOnView:self forError:error];
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (RMPhotoDrawerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    RMPhotoDrawerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.photo.image = [self.photos objectAtIndex:indexPath.row];
    // Return the cell
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // View or delete?
}

#pragma mark - UIImagePicker
#warning modify image selection in RMPhotoDrawer

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    imagePickerController.modalPresentationStyle = (sourceType == UIImagePickerControllerSourceTypeCamera) ? UIModalPresentationFullScreen : UIModalPresentationPopover;
    
    self.imagePickerController = imagePickerController; // we need this for later
    
    [self presentViewController:self.imagePickerController animated:YES completion:^{
        //.. done presenting
    }];
}


- (void)finishAndUpdate {
    // Dismiss the image picker.
    [self dismissViewControllerAnimated:YES completion:^{
        //.. done dismissing
    }];
    self.imagePickerController = nil;
    [self configureMessagePhotoView];
}

- (void)configureMessagePhotoView {
    /*
    // TODO: Replace image view with something more visually appealing
    // Check for images
#warning Fix images disappearing randomly
#warning Replace all this excuse of code for RMPhotoDrawer
    if (self.detailItem.photo != nil) {
        NSLog(@"Setting captured images to detailItem's photo array");
        [self.photos addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:self.detailItem.photo] ];
    }
    if ([self.photos count] > 0)
    {
        NSLog(@"Captured Images has more than 0 items");
        if ([self.photos count] == 1)
        {
            // Camera took a single picture.
            NSLog(@"Captured Images has only 1 item");
            [self.messagePhotoView setImage:[UIImage imageWithData:[self.capturedImages objectAtIndex:0]]];
        }
        else
        {
            NSLog(@"Captured Images has more than 1 item");
            // Camera took multiple pictures; use the list of images for animation.
            NSMutableArray *images = [[NSMutableArray alloc] init];
            for (NSData *data in self.photos) {
                [images addObject:[UIImage imageWithData:data]];
            }
            [self.messagePhotoView setAnimationImages:images];
            [self.messagePhotoView setAnimationDuration:5.0];    // Show each captured photo for 5 seconds.
            [self.messagePhotoView setAnimationRepeatCount:0];   // Animate forever (show all photos).
            [self.messagePhotoView startAnimating];
        }
    }
    */
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Adding image to captured images");
    UIImage *image;
    // Check for live photo, then edited, then original
    if (UIImagePNGRepresentation([info valueForKey:UIImagePickerControllerLivePhoto]) != nil) {
        image = [info valueForKey:UIImagePickerControllerLivePhoto];
    } else if ([info valueForKey:UIImagePickerControllerEditedImage] != nil) {
        image = [info valueForKey:UIImagePickerControllerEditedImage];
    } else {
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    // Add image to array
    [self.photos addObject:image];
    [self.collection reloadData];
    [self finishAndUpdate];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        //.. done dismissing
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
