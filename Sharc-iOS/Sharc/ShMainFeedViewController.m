//
//  ShMainFeedViewController.m
//  Sharc
//
//  Created by Clay Jones on 7/21/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShMainFeedViewController.h"
#import "ShConstants.h"
#import "ShFeedMainTableViewCell.h"
#import "ShUtils.h"
#import "ShSearchViewController.h"
#import "ShUserProfileViewController.h"
#import "ShDatabase.h"

@implementation ShMainFeedViewController {
    UITableView *_tableview;
    NSInteger _expandedCell;
    NSArray *_deals;
    UIRefreshControl *_refreshControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Background of Status bar
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.view addSubview:whiteView];
    
    [ShDatabase getDealsWithBlock:^(NSArray *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _deals = data;
            [_tableview reloadData];
        });
    }];
    [self renderLayout];
}

-(void) renderLayout {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.navigationController.navigationBar.tintColor = [ShUtils ShDarkGrayTextColor];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel setText:@"Deals"];
    [titleLabel setFont:[UIFont fontWithName:ShDefaultFontName size:18]];
    [titleLabel setTextColor:[ShUtils ShDarkGrayTextColor]];
    [titleLabel sizeToFit];
    [self.navigationItem setTitleView:titleLabel];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"profile_navbar_button"] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(profileSelected) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"search_navbar_button"] forState:UIControlStateNormal];
    [leftButton sizeToFit];
    [leftButton addTarget:self action:@selector(searchSelected) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableview];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_tableview insertSubview:_refreshControl atIndex:0];
    
    _expandedCell = NO_EXPANDED_CELLS;
}

-(void) handleRefresh: (UIRefreshControl *) refreshControl {
    [_refreshControl beginRefreshing];
    [ShDatabase getDealsWithBlock:^(NSArray *data) {
        _deals = data;
        [_tableview reloadData];
        [_refreshControl endRefreshing];
    }];
}

#pragma TableView Delegate/Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *deal = _deals[indexPath.section];
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"FeedCell";
        ShFeedMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ShFeedMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mainText = deal[@"deal_text"];
        cell.subText = deal[@"sub_text"];
        cell.merchantNameText = deal[@"merchant"][@"name"];
        cell.merchantID = deal[@"merchant"][@"merchant_id"];
        cell.distanceText = @"3.2mi";
        [self addSeperatorToCell:cell];
        cell.backgroundImage = nil;
        [self uploadImageForCellIndexPath:indexPath andDealID:deal[@"_id"]];
        return cell;
    }
    static NSString *cellId = @"ExpandedCell";
    ShFeedExpandedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ShFeedExpandedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.mainText = deal[@"deal_text"];
    cell.subText = deal[@"sub_text"];
    cell.merchantNameText = deal[@"merchant"][@"name"];
    cell.merchantID = deal[@"merchant"][@"merchant_id"];
    cell.distanceText = @"3.2mi";
    cell.detailText = deal[@"details"];
    cell.delegate = self;
    [self addSeperatorToCell:cell];
    return cell;
}

-(void) uploadImageForCellIndexPath: (NSIndexPath *) indexPath andDealID: (NSString *) dealID {
    [ShDatabase getImageForDealID:dealID withBlock:^(UIImage *image) {
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ShFeedMainTableViewCell *updateCell = (ShFeedMainTableViewCell *)[_tableview cellForRowAtIndexPath:indexPath];
                if (updateCell)
                    updateCell.backgroundImage = image;
            });
        }
    }];
}

-(void) addSeperatorToCell: (UITableViewCell *)cell {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINFEED_CELL_HEIGHT - 1.0, cell.contentView.frame.size.width, 1)];
    
    lineView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:lineView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _deals.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_expandedCell != NO_EXPANDED_CELLS && _expandedCell == section) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return MAINFEED_CELL_EXPANDED_HEIGHT;
    }
    return MAINFEED_CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (indexPath.row == 0) {
        ShFeedMainTableViewCell *cell = (ShFeedMainTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.section == _expandedCell) {
            cell.expanded = NO;
            _expandedCell = NO_EXPANDED_CELLS;
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
        } else if (indexPath.section != _expandedCell) {
            if (_expandedCell != NO_EXPANDED_CELLS) {
                ShFeedMainTableViewCell *othercell = (ShFeedMainTableViewCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_expandedCell]];
                othercell.expanded = NO;
                [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:_expandedCell]] withRowAnimation:UITableViewRowAnimationTop];
            }
            cell.expanded = YES;
            _expandedCell = indexPath.section;
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    [tableView endUpdates];
}

#pragma Expanded Cell Delegate methods

-(void)shExpandedCell:(ShFeedExpandedTableViewCell *)cell merchantButtonSelected:(NSString *)merchantID {
    ShMerchantProfileViewController *controller = [ShMerchantProfileViewController new];
    [controller setMerchantID:merchantID];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma nav bar selectors

-(void) searchSelected {
    ShSearchViewController *controller = [ShSearchViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void) profileSelected {
    [self.navigationController pushViewController:[ShUserProfileViewController new] animated:YES];
}

@end
