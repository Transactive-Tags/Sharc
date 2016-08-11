//
//  ShSearchResultsViewController.m
//  Sharc
//
//  Created by Clay Jones on 7/25/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShSearchResultsViewController.h"
#import "ShDealTableViewCell.h"
#import "ShDatabase.h"
#import "ShConstants.h"

@implementation ShSearchResultsViewController {
    UITableView *_tableView;
    NSArray *_deals;
}

-(void)viewDidLoad {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
    
    [ShDatabase getDealsWithBlock:^(NSArray *data) {
        if (data) {
            _deals = data;
            [_tableView reloadData];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ResultCell";
    ShDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ShDealTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSDictionary *deal = _deals[indexPath.row];
    cell.mainLabelText = deal[@"deal_text"];
    cell.subLabelText = deal[@"sub_text"];
    cell.detailImage = [UIImage imageNamed:@"pie"];
    [self uploadImageForCellIndexPath:indexPath andDealID:deal[@"_id"]];
//    cell.merchantNameText = deal[@"merchant"][@"name"];
//    cell.merchantID = deal[@"merchant"][@"merchant_id"];
//    cell.distanceText = @"3.2mi";
    cell.detailLabelText = deal[@"details"];
    return cell;
}

-(void) uploadImageForCellIndexPath: (NSIndexPath *) indexPath andDealID: (NSString *) dealID {
    [ShDatabase getImageForDealID:dealID withBlock:^(UIImage *image) {
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ShDealTableViewCell *updateCell = (ShDealTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
                if (updateCell)
                    updateCell.detailImage = image;
            });
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_deals) {
        return _deals.count;
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEAL_CELL_HEIGHT;
}

@end
