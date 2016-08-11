//
//  ShMerchantProfileViewController.h
//  Sharc
//
//  Created by Clay Jones on 7/22/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShMerchantProfileViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *merchantID;

@end
