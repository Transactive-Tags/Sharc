//
//  ShMerchantProfileViewController.m
//  Sharc
//
//  Created by Clay Jones on 7/22/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShMerchantProfileViewController.h"

@implementation ShMerchantProfileViewController {
    UIScrollView *_scrollView;
    UIImageView *_coverPhotoView;
    UIImageView *_profilePhotoView;
    UILabel *_businessNameLabel;
    UIButton *_followButton;
    UITableView *_dealsTableView;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self renderView];
}

-(void) renderView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [_scrollView setContentSize:self.view.frame.size];
    self.view = _scrollView;
    [_scrollView setScrollEnabled:YES];
    _scrollView.delegate = self;
    [_scrollView setBounces:YES];
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    [self renderHeaderView];
}

-(void) renderHeaderView {
    _coverPhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * .3)];
    [self.view addSubview:_coverPhotoView];
    [_coverPhotoView setBackgroundColor:[UIColor redColor]];
}

@end
