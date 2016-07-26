//
//  ShMainFeedViewController.h
//  Sharc
//
//  Created by Clay Jones on 7/21/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShFeedExpandedTableViewCell.h"

@interface ShMainFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ShExpandedFeedCellNavigationDelegate>

@end
