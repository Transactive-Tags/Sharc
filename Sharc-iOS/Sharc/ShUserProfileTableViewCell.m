//
//  ShUserProfileTableViewCell.m
//  Sharc
//
//  Created by Clay Jones on 7/26/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShUserProfileTableViewCell.h"
#import "ShConstants.h"

@implementation ShUserProfileTableViewCell {
    UILabel *_mainLabel;
    UIImageView *_iconView;
}

@synthesize mainLabelText = _mainLabelText;
@synthesize labelColor = _labelColor;
@synthesize iconImage = _iconImage;
@synthesize fontSize = _fontSize;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _mainLabel = [[UILabel alloc] init];
        [_mainLabel setFont:[UIFont fontWithName:ShDefaultFontName size:18]];
        [self addSubview:_mainLabel];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _iconView = [[UIImageView alloc] init];
        [self addSubview:_iconView];
    }
    return self;
}

-(void)layoutSubviews {
    [_mainLabel setFrame:CGRectMake((self.frame.size.width - _mainLabel.frame.size.width)/2, (self.frame.size.height - _mainLabel.frame.size.height)/2, _mainLabel.frame.size.width, _mainLabel.frame.size.height)];
    if (_iconImage) {
        [_iconView setImage:_iconImage];
        [_iconView sizeToFit];
        [_iconView setFrame:CGRectMake(_mainLabel.frame.origin.x - _iconView.frame.size.width - 5, (self.frame.size.height - _iconView.frame.size.height)/2, _iconView.frame.size.width, _iconView.frame.size.height)];
    }
    if (_mainLabelText) {
        
    }
}

-(void)setLabelColor:(UIColor *)labelColor {
    _labelColor = labelColor;
    _mainLabel.textColor = labelColor;
}

-(void)setMainLabelText:(NSString *)mainLabelText {
    _mainLabelText = mainLabelText;
    _mainLabel.text = _mainLabelText;
    [_mainLabel sizeToFit];
}

-(void) setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
}

-(void)setFontSize:(NSNumber *)fontSize {
    _fontSize = fontSize;
    [_mainLabel setFont:[UIFont fontWithName:ShDefaultFontName size:[_fontSize floatValue]]];
    [_mainLabel sizeToFit];
}

@end
