//
//  ShMerchantProfileViewController.m
//  Sharc
//
//  Created by Clay Jones on 7/22/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShMerchantProfileViewController.h"
#import "ShUtils.h"
#import "ShConstants.h"
#import "ShDealTableViewCell.h"
#import <MapKit/MapKit.h>
#import "ShDatabase.h"

@implementation ShMerchantProfileViewController {
    UIScrollView *_scrollView;
    UIImageView *_coverPhotoView;
    UIImageView *_profilePhotoView;
    UILabel *_businessNameLabel;
    UIButton *_followButton;
    UITableView *_dealsTableView;
    MKMapView *_mapView;
    UIView *_addressView;
    UIView *_phoneView;
    UIView *_websiteView;
}

@synthesize merchantID = _merchantID;

-(void)setMerchantID:(NSString *)merchantID {
    _merchantID = merchantID;
    [ShDatabase getMerchantForID:_merchantID withBlock:^(NSDictionary *dict) {
        if (dict) {
            [_businessNameLabel setText:dict[@"name"]];
            [self renderMainLabels];
        } else {
            [_businessNameLabel setText:@"Merchant Name"];
            [self renderMainLabels];
        }
    }];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    _businessNameLabel = [UILabel new];
    [self renderView];
}

-(void) renderView {
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    self.view = _scrollView;
    [_scrollView setScrollEnabled:YES];
    [self.view setBackgroundColor:[ShUtils ShLightGrayBackgroundColor]];
    _scrollView.delegate = self;
    [_scrollView setBounces:YES];
    
    [self renderHeaderView];
}

//# MARK: - Render View

-(void) renderHeaderView {
    _coverPhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * .3)];
    [self.view addSubview:_coverPhotoView];
    [_coverPhotoView setImage:[UIImage imageNamed:@"sandwich"]];
    
    [self renderProfilePhoto];
    [self renderMainLabels];
    [self renderDealTable];
    [self renderMapView];
    [self renderContactButtons];
}

- (void) renderProfilePhoto {
    CGSize coverphotoSize = _coverPhotoView.frame.size;
    
    _profilePhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, coverphotoSize.height * .4, coverphotoSize.height * .8, coverphotoSize.height * .8)];
    [_profilePhotoView.layer setCornerRadius:_profilePhotoView.frame.size.width * .1];
    [_profilePhotoView setClipsToBounds:YES];
    [_profilePhotoView.layer setBorderWidth:3];
    [_profilePhotoView.layer setBorderColor:[ShUtils ShLightGrayBackgroundColor].CGColor];
    [_profilePhotoView setImage:[UIImage imageNamed:@"profpic"]];
    
    [_coverPhotoView addSubview:_profilePhotoView];
}

-(void) renderMainLabels {
    [_businessNameLabel setFont:[UIFont fontWithName: ShDefaultFontName size:18]];
    [_businessNameLabel setTextColor:[UIColor whiteColor]];
    [_businessNameLabel sizeToFit];
    
    CGRect picRect = _profilePhotoView.frame;
    
    [_businessNameLabel setFrame:CGRectMake(picRect.origin.x + picRect.size.width + 10, picRect.origin.y, _businessNameLabel.frame.size.width, _businessNameLabel.frame.size.height)];
    
    [_coverPhotoView addSubview:_businessNameLabel];
}

-(void) renderDealTable {
    CGRect coverRect = _coverPhotoView.bounds;
    _dealsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, coverRect.origin.y + coverRect.size.height + 30, self.view.frame.size.width, DEAL_CELL_HEIGHT * NUMBER_OF_CELLS_IN_MERCHANT_VIEW) style:UITableViewStylePlain];
    [_dealsTableView setDelegate:self];
    [_dealsTableView setDataSource:self];
    [_dealsTableView setScrollEnabled: NO];
    [self.view addSubview:_dealsTableView];
}

-(void) renderMapView {
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, _dealsTableView.frame.origin.y + _dealsTableView.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.width * .3)];
    [self.view addSubview:_mapView];
}

-(void) renderContactButtons {
    _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, _mapView.frame.origin.y + _mapView.frame.size.height, self.view.frame.size.width, 40)];
    [_addressView setBackgroundColor:[UIColor whiteColor]];
    UILabel *addressLabel = [[UILabel alloc] init];
    [addressLabel setText:@"6324 La Pintura Dr. La Jolla, CA 92037"];
    [addressLabel setFont:[UIFont fontWithName:ShDefaultFontName size:12]];
    [addressLabel setTextColor:[ShUtils ShBlueTextColor]];
    [addressLabel sizeToFit];
    [addressLabel setFrame:CGRectMake(_addressView.frame.size.width/2 - addressLabel.frame.size.width/2, _addressView.frame.size.height/2 - addressLabel.frame.size.height/2, addressLabel.frame.size.width, addressLabel.frame.size.height)];
    [_addressView addSubview:addressLabel];
    [self.view addSubview:_addressView];
    
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressButtonSelected)];
    [_addressView addGestureRecognizer:addressTap];
    
    _phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, _addressView.frame.origin.y + _addressView.frame.size.height + 1, self.view.frame.size.width/2 - .5, 40)];
    [_phoneView setBackgroundColor:[UIColor whiteColor]];
    UILabel *phoneLabel = [[UILabel alloc] init];
    [phoneLabel setText:@"858-472-3180"];
    [phoneLabel setFont:[UIFont fontWithName:ShDefaultFontName size:12]];
    [phoneLabel setTextColor:[ShUtils ShBlueTextColor]];
    [phoneLabel sizeToFit];
    [phoneLabel setFrame:CGRectMake(_phoneView.frame.size.width/2 - phoneLabel.frame.size.width/2, _phoneView.frame.size.height/2 - phoneLabel.frame.size.height/2, phoneLabel.frame.size.width, phoneLabel.frame.size.height)];
    [_phoneView addSubview:phoneLabel];
    
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone_icon"]];
    [phoneIcon sizeToFit];
    [phoneIcon setClipsToBounds:YES];
    [phoneIcon setFrame:CGRectMake(phoneLabel.frame.origin.x - phoneIcon.frame.size.width - 5, _phoneView.frame.size.height/2 - phoneIcon.frame.size.height/2, phoneIcon.frame.size.width, phoneIcon.frame.size.height)];
    [_phoneView addSubview:phoneIcon];
    
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callButtonSelected)];
    [_phoneView addGestureRecognizer:phoneTap];
    
    [self.view addSubview:_phoneView];
    
    _websiteView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + .5, _addressView.frame.origin.y + _addressView.frame.size.height + 1, self.view.frame.size.width/2 - .5, 40)];
    [_websiteView setBackgroundColor:[UIColor whiteColor]];
    UILabel *websiteLabel = [[UILabel alloc] init];
    [websiteLabel setText:@"Website"];
    [websiteLabel setFont:[UIFont fontWithName:ShDefaultFontName size:12]];
    [websiteLabel setTextColor:[ShUtils ShBlueTextColor]];
    [websiteLabel sizeToFit];
    [websiteLabel setFrame:CGRectMake(_websiteView.frame.size.width/2 - websiteLabel.frame.size.width/2, _websiteView.frame.size.height/2 - websiteLabel.frame.size.height/2, websiteLabel.frame.size.width, websiteLabel.frame.size.height)];
    [_websiteView addSubview:websiteLabel];
    
    UITapGestureRecognizer *websiteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteButtonSelected)];
    [_websiteView addGestureRecognizer:websiteTap];
    
    UIImageView *websiteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"website_icon"]];
    [websiteIcon sizeToFit];
    [websiteIcon setClipsToBounds:YES];
    [websiteIcon setFrame:CGRectMake(websiteLabel.frame.origin.x - websiteIcon.frame.size.width - 5, _websiteView.frame.size.height/2 - websiteIcon.frame.size.height/2, websiteIcon.frame.size.width, websiteIcon.frame.size.height)];
    [_websiteView addSubview:websiteIcon];
    
    [self.view addSubview:_websiteView];
}

//# MARK: - TableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const cellIdentifier = @"deal cell";
    ShDealTableViewCell *cell = [_dealsTableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (!cell) {
        cell = [[ShDealTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.mainLabelText = @"$2 Off";
    cell.subLabelText = @"All sandwiches";
    cell.detailLabelText = @"This is a really long detail label text that deals with all of the text wrapping bullshit that I need to deal with because iOS is annoying when it comes to wrapping text.";
    cell.detailImage = [UIImage imageNamed:@"pie"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEAL_CELL_HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(void) callButtonSelected {
    NSString *phNo = @"18584723180";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

-(void) websiteButtonSelected {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
    
}

-(void) addressButtonSelected {
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(16.775, -3.009);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"My Place"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

@end
