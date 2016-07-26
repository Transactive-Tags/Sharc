//
//  ShUserProfileViewController.m
//  Sharc
//
//  Created by Clay Jones on 7/22/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShUserProfileViewController.h"
#import "ShUtils.h"

@implementation ShUserProfileViewController {
    UIImageView *_profilePicture;
    UILabel *_profileNameLabel;
    UITableView *_tableview;
    NSArray *_tableOptions;
    
    UIImagePickerController *_imgPickerController;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setTableOptions];
    [self renderLayout];
}

//# MARK: - Set Table Options

-(void) setTableOptions {
    _tableOptions = @[
                      @{
                          @"Label":@"Following",
                          @"Icon":[UIImage imageNamed:@"profile_navbar_button"],
                          @"Color":[ShUtils ShDarkGrayTextColor],
                          @"Font-Size":@14,
                          @"Action": [NSValue valueWithPointer:@selector(optionSelected)]
                        },
                      @{
                          @"Label":@"Settings",
                          @"Icon":[UIImage imageNamed:@"profile_navbar_button"],
                          @"Color":[ShUtils ShDarkGrayTextColor],
                          @"Action": [NSValue valueWithPointer:@selector(optionSelected)]
                        },
                      @{
                          @"Label":@"Become a Sharc Merchant",
                          @"Icon":[UIImage imageNamed:@"profile_navbar_button"],
                          @"Color":[ShUtils ShDarkGrayTextColor],
                          @"Action": [NSValue valueWithPointer:@selector(optionSelected)]
                        },
                      @{
                          @"Label":@"Sign Out",
                          @"Icon":[UIImage imageNamed:@"profile_navbar_button"],
                          @"Color":[UIColor redColor],
                          @"Action": [NSValue valueWithPointer:@selector(optionSelected)]
                        },
                      ];
}

//# MARK: - Render View

-(void) renderLayout {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self renderProfilePicture];
    [self renderLabels];
    [self renderTableView];
}

-(void) renderProfilePicture {
    _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height * .2 - 50, 100, 100)];
    _profilePicture.layer.cornerRadius = _profilePicture.frame.size.width / 2;
    _profilePicture.clipsToBounds = YES;
    [_profilePicture setBackgroundColor:[UIColor blackColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePhotoTapped)];
    [_profilePicture setUserInteractionEnabled:YES];
    [_profilePicture addGestureRecognizer:tap];
    [self.view addSubview:_profilePicture];
}

-(void) renderLabels {
    _profileNameLabel = [[UILabel alloc] init];
    [_profileNameLabel setTextColor:[ShUtils ShDarkGrayTextColor]];
    [_profileNameLabel setText:@"Clay Jones"];
    [_profileNameLabel sizeToFit];
    
    [_profileNameLabel setFrame: CGRectMake((self.view.frame.size.width - _profileNameLabel.frame.size.width)/2, _profilePicture.frame.origin.y + _profilePicture.frame.size.height + 5, _profileNameLabel.frame.size.width, _profileNameLabel.frame.size.height)];
    [self.view addSubview: _profileNameLabel];
}

-(void) renderTableView {
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    [self.view addSubview:_tableview];
}

//# MARK: - gesture responders

-(void) profilePhotoTapped {
    _imgPickerController = [UIImagePickerController new];
    _imgPickerController.allowsEditing = NO;
    _imgPickerController.delegate = self;
    [_imgPickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:_imgPickerController animated:YES completion:nil];
}

//# MARK: - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    if (pickedImage) {
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:pickedImage];
        imageCropVC.delegate = self;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController pushViewController:imageCropVC animated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//# MARK: - tableview delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Option Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSDictionary *cellOption = _tableOptions[indexPath.row];
    cell.textLabel.textColor = cellOption[@"Color"];
    cell.textLabel.text = cellOption[@"Label"];
    return cell;
}

//# MARK: - tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableOptions.count;
}

-(void) optionSelected {
    
}

//# MARK: - RSKImageCropViewConroller Delegate

// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    _profilePicture.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    _profilePicture.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage
{
//    // Use when `applyMaskToCroppedImage` set to YES.
//    [SVProgressHUD show];
}

//# MARK: - RSKImageCropViewConroller Datasource

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    CGSize maskSize;
    if ([controller isPortraitInterfaceOrientation]) {
        maskSize = CGSizeMake(250, 250);
    } else {
        maskSize = CGSizeMake(220, 220);
    }
    
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                 (viewHeight - maskSize.height) * 0.5f,
                                 maskSize.width,
                                 maskSize.height);
    
    return maskRect;
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:point1];
    [triangle addLineToPoint:point2];
    [triangle addLineToPoint:point3];
    [triangle closePath];
    
    return triangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    // If the image is not rotated, then the movement rect coincides with the mask rect.
    return controller.maskRect;
}

@end
