//
//  ShDealTableViewCell.m
//  Sharc
//
//  Created by Clay Jones on 8/3/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShDealTableViewCell.h"
#import "ShConstants.h"
#import "ShUtils.h"

@implementation ShDealTableViewCell {
    UILabel *_mainLabel;
    UIImageView *_detailImageView;
    UILabel *_subLabel;
    UILabel *_timeLabel;
    UILabel *_detailLabel;
}

@synthesize detailImage = _detailImage;
@synthesize mainLabelText = _mainLabelText;
@synthesize subLabelText = _subLabelText;
@synthesize detailLabelText = _detailLabelText;
@synthesize timeLabelText = _timeLabelText;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _mainLabel = [UILabel new];
        [_mainLabel setFont:[UIFont fontWithName:ShDefaultFontName size:14]];
        [_mainLabel setTextColor:[ShUtils ShDarkGrayTextColor]];
        [self addSubview:_mainLabel];
        
        _subLabel = [UILabel new];
        [_subLabel setFont:[UIFont fontWithName:ShDefaultFontName size:14]];
        [_subLabel setTextColor:[ShUtils ShDarkGrayTextColor]];
        [self addSubview:_subLabel];
        
        _timeLabel = [UILabel new];
        [_timeLabel setFont:[UIFont fontWithName:ShDefaultFontName size:14]];
        [_timeLabel setTextColor:[ShUtils ShDarkGrayTextColor]];
        [self addSubview:_subLabel];
        
        _detailLabel = [UILabel new];
        [_detailLabel setFont:[UIFont fontWithName:ShDefaultFontName size:10]];
        [_detailLabel setTextColor:[ShUtils ShDarkGrayTextColor]];
        [self addSubview:_detailLabel];
        
        _detailImageView = [UIImageView new];
        [self addSubview:_detailImageView];
    }
    return self;
}

-(void)setMainLabelText:(NSString *)mainLabelText {
    _mainLabelText = mainLabelText;
    [_mainLabel setText:_mainLabelText];
    [_mainLabel sizeToFit];
}

- (void) setSubLabelText:(NSString *)subLabelText {
    _subLabelText = subLabelText;
    [_subLabel setText:_subLabelText];
    [_subLabel sizeToFit];
}

- (void) setTimeLabelText:(NSString *)timeLabelText {
    _timeLabelText = timeLabelText;
    [_timeLabel setText:_timeLabelText];
    [_timeLabel sizeToFit];
}

- (void)setDetailLabelText:(NSString *)detailLabelText {
    _detailLabelText = detailLabelText;
    [_detailLabel setText:_detailLabelText];
    [_detailLabel sizeToFit];
}

-(void)setDetailImage:(UIImage *)detailImage {
    _detailImage = detailImage;
    [_detailImageView setImage:_detailImage];
    [_detailImageView setClipsToBounds:YES];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [_detailImageView setFrame:CGRectMake(5, self.frame.size.height * .1, self.frame.size.height * .8, self.frame.size.height * .8)];
    [_mainLabel setFrame:CGRectMake(_detailImageView.frame.origin.x + _detailImageView.frame.size.width + 5, _detailImageView.frame.origin.y, _mainLabel.frame.size.width, _mainLabel.frame.size.height)];
    [_subLabel setFrame:CGRectMake(_mainLabel.frame.origin.x, _mainLabel.frame.origin.y + _mainLabel.frame.size.height - 3, _subLabel.frame.size.width, _subLabel.frame.size.height)];
    [_detailLabel setFrame:CGRectMake(_mainLabel.frame.origin.x, _mainLabel.frame.origin.y + _mainLabel.frame.size.height - 3, _subLabel.frame.size.width, _subLabel.frame.size.height)];
    [_detailLabel setNumberOfLines:0];
    [_detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    CGRect detailRect = [_detailLabel.attributedText boundingRectWithSize:CGSizeMake(self.frame.size.width - _mainLabel.frame.origin.x - 10, CGFLOAT_MAX)                                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                     context:nil];
    [_detailLabel setFrame:CGRectMake(_mainLabel.frame.origin.x, _subLabel.frame.origin.y + _subLabel.frame.size.height - 3, detailRect.size.width, detailRect.size.height)];
}

@end
