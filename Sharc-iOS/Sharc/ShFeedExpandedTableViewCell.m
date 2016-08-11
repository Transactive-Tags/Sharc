//
//  ShFeedExpandedTableViewCell.m
//  Sharc
//
//  Created by Clay Jones on 7/21/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShFeedExpandedTableViewCell.h"
#import "ShUtils.h"
#import "ShConstants.h"

@implementation ShFeedExpandedTableViewCell {
    UILabel *_mainTextLabel;
    UILabel *_subTextLabel;
    UILabel *_distanceTextLabel;
    UILabel *_detailTextLabel;
    UIButton *_merchantNameTextLabel;
}

@synthesize mainText = _mainText;
@synthesize subText = _subText;
@synthesize distanceText = _distanceText;
@synthesize merchantNameText = _merchantNameText;
@synthesize detailText = _detailText;
@synthesize merchantID = _merchantID;

@synthesize expanded = _expanded;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _mainText = @"";
        _subText = @"";
        _distanceText = @"";
        _merchantNameText = @"";
        
        _mainTextLabel = [UILabel new];
        [_mainTextLabel setFont:[UIFont fontWithName:ShDefaultFontName size:14]];
        [_mainTextLabel setTextColor:[ShUtils ShDarkGrayTextColor]];
        [self addSubview:_mainTextLabel];
        
        _subTextLabel = [UILabel new];
        [_subTextLabel setFont:[UIFont fontWithName:ShDefaultFontName size:12]];
        [_subTextLabel setTextColor:[ShUtils ShDarkGrayTextColor]];
        [self addSubview:_subTextLabel];
        
        _distanceTextLabel = [UILabel new];
        [_distanceTextLabel setFont:[UIFont fontWithName:ShDefaultFontName size:12]];
        [_distanceTextLabel setTextColor:[ShUtils ShDarkGrayTextColor]];
        [self addSubview:_distanceTextLabel];
        
        _merchantNameTextLabel = [UIButton new];
        [_merchantNameTextLabel.titleLabel setFont:[UIFont fontWithName:ShDefaultFontName size:12]];
        [_merchantNameTextLabel.titleLabel setTintColor:[UIColor blueColor]];
        [_merchantNameTextLabel setTitleColor:[ShUtils ShBlueTextColor] forState:UIControlStateNormal];
        [_merchantNameTextLabel setUserInteractionEnabled:YES];
        [_merchantNameTextLabel addTarget:self action:@selector(merchantButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_merchantNameTextLabel];
        
        _detailTextLabel = [UILabel new];
        [_detailTextLabel setFont:[UIFont fontWithName:ShDefaultFontName size:12]];
        [_detailTextLabel setTextColor:[ShUtils ShDarkGrayTextColor]];
        [_detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_detailTextLabel setNumberOfLines:0];
        [self addSubview:_detailTextLabel];
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
    [_merchantNameTextLabel setTitle:_merchantNameText forState:UIControlStateNormal];
    [_merchantNameTextLabel sizeToFit];
}

-(void)setDetailText:(NSString *)detailText {
    _detailText = detailText;
    _detailTextLabel.text = _detailText;
    [_detailTextLabel sizeThatFits:CGSizeMake(self.frame.size.width * .9, 100)];
}

-(void) setExpanded:(BOOL)expanded {
    _expanded = expanded;
}

-(void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat leftMargin = 8;
    [super layoutSubviews];
    [_mainTextLabel setFrame:CGRectMake(leftMargin, 2, _mainTextLabel.frame.size.width, _mainTextLabel.frame.size.height)];
    [_subTextLabel setFrame:CGRectMake(leftMargin, _mainTextLabel.frame.origin.y + _mainTextLabel.frame.size.height, _subTextLabel.frame.size.width, _subTextLabel.frame.size.height)];
    [_merchantNameTextLabel setFrame:CGRectMake(leftMargin, _subTextLabel.frame.origin.y + _subTextLabel.frame.size.height, _merchantNameTextLabel.frame.size.width, _subTextLabel.frame.size.height)];
    [_distanceTextLabel setFrame:CGRectMake(width - _distanceTextLabel.frame.size.width - leftMargin, 2, _distanceTextLabel.frame.size.width, _distanceTextLabel.frame.size.height)];
    
    CGSize  textSize = { self.frame.size.width * .9, 1000 };
    CGSize size = [[NSString stringWithFormat:@"%@", _detailText]
                   sizeWithFont:_detailTextLabel.font
                   constrainedToSize:textSize
                   lineBreakMode:NSLineBreakByWordWrapping];
    [_detailTextLabel setFrame:CGRectMake(leftMargin, _merchantNameTextLabel.frame.origin.y + _merchantNameTextLabel.frame.size.height + 2, size.width, size.height)];
}

-(void) merchantButtonSelected: (UIButton *) sender {
    [self.delegate shExpandedCell:self merchantButtonSelected:_merchantID];
}

@end
