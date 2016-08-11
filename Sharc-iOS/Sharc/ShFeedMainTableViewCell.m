//
//  ShFeedMainTableViewCell.m
//  Sharc
//
//  Created by Clay Jones on 7/21/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShFeedMainTableViewCell.h"
#import "ShUtils.h"
#import "ShConstants.h"

@implementation ShFeedMainTableViewCell {
    UILabel *_mainTextLabel;
    UILabel *_subTextLabel;
    UILabel *_distanceTextLabel;
    UILabel *_merchantNameTextLabel;
    
    UIImageView *_imageView;
    UIView *_overlayView;
}

@synthesize mainText = _mainText;
@synthesize subText = _subText;
@synthesize distanceText = _distanceText;
@synthesize merchantNameText = _merchantNameText;
@synthesize expanded = _expanded;
@synthesize backgroundImage = _backgroundImage;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _mainText = @"";
        _subText = @"";
        _distanceText = @"";
        _merchantNameText = @"";
        
        _imageView = [[UIImageView alloc] init];
        [self setBackgroundView:_imageView];
        
        _overlayView = [UIView new];
        [_overlayView setBackgroundColor:[ShUtils tableViewCellOverlayColor]];
        [self addSubview:_overlayView];
        [_overlayView setAlpha:.6f];
        
        _mainTextLabel = [UILabel new];
        [_mainTextLabel setFont:[UIFont fontWithName:ShDefaultBoldFontName size:24]];
        [_mainTextLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_mainTextLabel];
        
        _subTextLabel = [UILabel new];
        [_subTextLabel setFont:[UIFont fontWithName:ShDefaultBoldFontName size:18]];
        [_subTextLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_subTextLabel];
        
        _distanceTextLabel = [UILabel new];
        [_distanceTextLabel setFont:[UIFont fontWithName:ShDefaultFontName size:16]];
        [_distanceTextLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_distanceTextLabel];
        
        _merchantNameTextLabel = [UILabel new];
        [_merchantNameTextLabel setFont:[UIFont fontWithName:ShDefaultFontName size:16]];
        [_merchantNameTextLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_merchantNameTextLabel];
    }
    return self;
}

-(void)setMainText:(NSString *)mainText {
    _mainText = mainText;
    _mainTextLabel.text = _mainText;
    [_mainTextLabel sizeToFit];
}

-(void)setSubText:(NSString *)subText {
    _subText = subText;
    _subTextLabel.text = _subText;
    [_subTextLabel sizeToFit];
}

-(void)setDistanceText:(NSString *)distanceText {
    _distanceText = distanceText;
    _distanceTextLabel.text = _distanceText;
    [_distanceTextLabel sizeToFit];
}

-(void)setMerchantNameText:(NSString *)merchantNameText {
    _merchantNameText = merchantNameText;
    _merchantNameTextLabel.text = _merchantNameText;
    [_merchantNameTextLabel sizeToFit];
}

-(void) setExpanded:(BOOL)expanded {
    _expanded = expanded;
    [UIView animateWithDuration:0.5f animations:^(void) {
        if (expanded) {
            [_overlayView setAlpha:0.0f];
            for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    [view setAlpha:0.0f];
                }
            }
        } else {
            [_overlayView setAlpha:0.6f];
            for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    [view setAlpha:1.0f];
                }
            }
        }
    }];
}

-(void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [_imageView setImage:backgroundImage];
}

-(void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    [super layoutSubviews];
    [_overlayView setFrame:CGRectMake(0, 0, width - 1, height - 1)];
    [_imageView setFrame:CGRectMake(0, 0, width, height)];
    [_mainTextLabel setFrame:CGRectMake((width - _mainTextLabel.frame.size.width) / 2, height/2 - _mainTextLabel.frame.size.height + 2, _mainTextLabel.frame.size.width, _mainTextLabel.frame.size.height)];
    [_subTextLabel setFrame:CGRectMake((width - _subTextLabel.frame.size.width) / 2, height/2, _subTextLabel.frame.size.width, _subTextLabel.frame.size.height)];
    [_merchantNameTextLabel setFrame:CGRectMake(2, 2, _merchantNameTextLabel.frame.size.width, _merchantNameTextLabel.frame.size.height)];
    [_distanceTextLabel setFrame:CGRectMake(width - _distanceTextLabel.frame.size.width - 2, 2, _distanceTextLabel.frame.size.width, _distanceTextLabel.frame.size.height)];
}

@end
