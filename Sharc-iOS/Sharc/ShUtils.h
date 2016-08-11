//
//  ShUtils.h
//  Sharc
//
//  Created by Clay Jones on 7/21/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShUtils : NSObject

+(UIFont *)mainLabelFontWithSize: (CGFloat) size;

+(UIColor *) tableViewCellOverlayColor;
+(UIColor *) ShDarkGrayTextColor;
+(UIColor *) ShLightGrayColor;
+(UIColor *) ShLightGrayBackgroundColor;
+(UIColor *) ShBlueTextColor;

@end
