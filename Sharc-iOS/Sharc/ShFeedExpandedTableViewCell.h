//
//  ShFeedExpandedTableViewCell.h
//  Sharc
//
//  Created by Clay Jones on 7/21/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShMerchantProfileViewController.h"

@class ShFeedExpandedTableViewCell;

@protocol ShExpandedFeedCellNavigationDelegate <NSObject>
-(void)shExpandedCell: (ShFeedExpandedTableViewCell *)cell merchantButtonSelected: (NSString *)merchantID;
@end

@interface ShFeedExpandedTableViewCell : UITableViewCell

@property (nonatomic, retain) id<ShExpandedFeedCellNavigationDelegate> delegate;

@property (strong, nonatomic) NSString *mainText;
@property (strong, nonatomic) NSString *subText;
@property (strong, nonatomic) NSString *distanceText;
@property (strong, nonatomic) NSString *merchantNameText;
@property (strong, nonatomic) NSString *detailText;
@property (strong, nonatomic) NSString *merchantID;

@property (nonatomic) BOOL expanded;

@end
