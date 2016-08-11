//
//  ShFeedMainTableViewCell.h
//  Sharc
//
//  Created by Clay Jones on 7/21/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShFeedMainTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *mainText;
@property (strong, nonatomic) NSString *subText;
@property (strong, nonatomic) NSString *distanceText;
@property (strong, nonatomic) NSString *merchantNameText;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) NSString *merchantID;

@property (nonatomic) BOOL expanded;

@end
