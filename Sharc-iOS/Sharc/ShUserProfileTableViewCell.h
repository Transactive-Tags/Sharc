//
//  ShUserProfileTableViewCell.h
//  Sharc
//
//  Created by Clay Jones on 7/26/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShUserProfileTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *mainLabelText;
@property (strong, nonatomic) UIColor *labelColor;
@property (strong, nonatomic) UIImage *iconImage;
@property (strong, nonatomic) NSNumber *fontSize;

@end
