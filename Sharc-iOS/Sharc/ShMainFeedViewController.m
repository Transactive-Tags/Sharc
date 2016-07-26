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

@implementation ShMainFeedViewController {
    UITableView *_tableview;
    NSInteger _expandedCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self renderLayout];
}

-(void) renderLayout {
    
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
    
    _tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableview];
    
    _expandedCell = NO_EXPANDED_CELLS;
}

#pragma TableView Delegate/Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"FeedCell";
        ShFeedMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ShFeedMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mainText = @"Main Text";
        cell.subText = @"Sub Text";
        cell.merchantNameText = @"Merchant name text";
        cell.distanceText = @"3.2mi";
        [self addSeperatorToCell:cell];
        return cell;
    }
    static NSString *cellId = @"ExpandedCell";
    ShFeedExpandedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ShFeedExpandedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.mainText = @"Main Text";
    cell.subText = @"Sub Text";
    cell.merchantNameText = @"Merchant name text";
    cell.distanceText = @"3.2mi";
    cell.detailText = @"$2 off any purchase of a large sub and a large soda. Only at this participating location. Present this deal at the counter.";
    cell.delegate = self;
    [self addSeperatorToCell:cell];
    return cell;
}

-(void) addSeperatorToCell: (UITableViewCell *)cell {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINFEED_CELL_HEIGHT - 1.0, cell.contentView.frame.size.width, 1)];
    
    lineView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:lineView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_expandedCell != NO_EXPANDED_CELLS && _expandedCell == section) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
