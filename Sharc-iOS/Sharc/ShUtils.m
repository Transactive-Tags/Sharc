//
//  ShUtils.m
//  Sharc
//
//  Created by Clay Jones on 7/21/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShUtils.h"

@implementation ShUtils

+(UIFont *)mainLabelFontWithSize: (CGFloat) size {
    return [UIFont fontWithName:@"AppleSDGothicNeo-Regular " size:size];
}

+(UIColor *) tableViewCellOverlayColor {
    return [UIColor colorWithRed:(74.0f/255.0)
                           green:(74.0f/255.0)
                            blue:(74.0f/255.0)
                           alpha:1.0f];
}

+(UIColor *) ShDarkGrayTextColor {
    return [UIColor colorWithRed:(47.0f/255.0)
                           green:(54.0f/255.0)
                            blue:(59.0f/255.0)
                           alpha:1.0f];
}

+(UIColor *) ShLightGrayColor {
    return [UIColor colorWithRed:(178.0f/255.0)
                           green:(178.0f/255.0)
                            blue:(178.0f/255.0)
                           alpha:0.20f];
}

+(UIColor *) ShLightGrayBackgroundColor {
    return [UIColor colorWithRed:(246.0f/255.0)
                           green:(248.0f/255.0)
                            blue:(250.0f/255.0)
                           alpha:1.0f];
}

+(UIColor *) ShBlueTextColor {
    return [UIColor colorWithRed:(74.0f/255.0)
                           green:(144.0f/255.0)
                            blue:(226.0f/255.0)
                           alpha:1.0f];
}

@end
