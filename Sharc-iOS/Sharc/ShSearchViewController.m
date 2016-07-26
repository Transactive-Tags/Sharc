//
//  ShSearchViewController.m
//  Sharc
//
//  Created by Clay Jones on 7/22/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShSearchViewController.h"
#import "ShUtils.h"
#import "ShConstants.h"
#import "ShSuggestedSearchViewController.h"
#import "ShSearchAutocompleteViewController.h"
#import "ShSearchResultsViewController.h"

@implementation ShSearchViewController {
    UITextField *_searchBarField;
    
    UIViewController *_currentVC;
    
    ShSuggestedSearchViewController *_suggestVC;
    ShSearchAutocompleteViewController *_autoCompleteVC;
    ShSearchResultsViewController *_resultsVC;
    
}

-(instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self renderLayout];
    
    _suggestVC = [ShSuggestedSearchViewController new];
    _autoCompleteVC = [ShSearchAutocompleteViewController new];
    _resultsVC = [ShSearchResultsViewController new];
    
    [self setCurrentViewController:_suggestVC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:_searchBarField];
}

-(void) setCurrentViewController: (UIViewController *) controller {
    for (UIViewController *childVC in self.childViewControllers) {
        if ([childVC isEqual:controller]) {
            return;
        }
        childVC.view.alpha = 1.0f;
        [UIView animateWithDuration:.25f animations:^{
            childVC.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [childVC.view removeFromSuperview];
            [childVC removeFromParentViewController];
        }];
    }
    controller.view.frame = CGRectMake(0, _searchBarField.frame.origin.y + _searchBarField.frame.size.height, self.view.frame.size.width, self.view.frame.size.width - (_searchBarField.frame.origin.y + _searchBarField.frame.size.height));
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    controller.view.alpha = 0.0f;
    [UIView animateWithDuration:.25f animations:^{
        controller.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

-(void) renderSearchBar {
    _searchBarField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.frame.size.width, SEARCH_BAR_HEIGHT)];
    _searchBarField.delegate = self;
    [_searchBarField setReturnKeyType:UIReturnKeySearch];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, _searchBarField.frame.size.height)];
    _searchBarField.leftView = paddingView;
    _searchBarField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_bar_icon"]];
    [searchIcon sizeToFit];
    [searchIcon setFrame:CGRectMake((paddingView.frame.size.width - searchIcon.frame.size.width)/2, (paddingView.frame.size.height - searchIcon.frame.size.height)/2, searchIcon.frame.size.width, searchIcon.frame.size.height)];
    [paddingView addSubview:searchIcon];
    
    UIView *toplineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _searchBarField.frame.size.width, 1)];
    toplineView.backgroundColor = [ShUtils ShLightGrayColor];
    [_searchBarField addSubview:toplineView];
    
    UIView *bottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, _searchBarField.frame.size.height - 1, _searchBarField.frame.size.width, 1)];
    bottomlineView.backgroundColor = [ShUtils ShLightGrayColor];
    [_searchBarField addSubview:bottomlineView];
    
    [_searchBarField setPlaceholder:@"Search"];
    [self.view addSubview:_searchBarField];
}

-(void) renderLayout {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSearch)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    [self renderSearchBar];
}

-(void) cancelSearch {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidChange :(NSNotification *)notification{
    if (_searchBarField.text.length == 0) {
        [self setCurrentViewController:_suggestVC];
    } else {
        [self setCurrentViewController:_autoCompleteVC];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_searchBarField.text.length == 0) {
        [self setCurrentViewController:_suggestVC];
    } else {
        [self setCurrentViewController:_autoCompleteVC];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        [self setCurrentViewController:_suggestVC];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchButtonTapped];
    return NO;
}

-(void) searchButtonTapped {
    [self setCurrentViewController:_resultsVC];
    [_searchBarField endEditing:YES];
}

@end
