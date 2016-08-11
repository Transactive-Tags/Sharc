//
//  ShDealTableViewCell.h
//  Sharc
//
//  Created by Clay Jones on 8/3/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShDealTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImage *detailImage;
@property (strong, nonatomic) NSString *mainLabelText;
@property (strong, nonatomic) NSString *subLabelText;
@property (strong, nonatomic) NSString *detailLabelText;
@property (strong, nonatomic) NSString *timeLabelText;

@end
