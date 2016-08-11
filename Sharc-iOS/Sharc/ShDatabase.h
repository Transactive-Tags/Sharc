//
//  ShDatabase.h
//  Sharc
//
//  Created by Clay Jones on 7/28/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShDatabase : NSObject

+ (void) getDealsWithBlock:(void (^)(NSArray *data))block;
+(void) getImageForDealID: (NSString *) dealID withBlock: (void (^)(UIImage *image))block;
+(void) getMerchantForID: (NSString *) merchantID withBlock: (void (^)(NSDictionary *dict))block;

@end
