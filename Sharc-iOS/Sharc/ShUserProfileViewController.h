//
//  ShUserProfileViewController.h
//  Sharc
//
//  Created by Clay Jones on 7/22/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSKImageCropper/RSKImageCropper.h>

@interface ShUserProfileViewController : UIViewController <RSKImageCropViewControllerDataSource, RSKImageCropViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@end
