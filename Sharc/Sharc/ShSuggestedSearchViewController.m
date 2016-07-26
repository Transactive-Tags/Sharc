//
//  ShSuggestedSearchViewController.m
//  Sharc
//
//  Created by Clay Jones on 7/25/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShSuggestedSearchViewController.h"

@implementation ShSuggestedSearchViewController {
    UITableView *_tableView;
}

-(void)viewDidLoad {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SuggestedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = @"Suggest Cell";
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

@end
