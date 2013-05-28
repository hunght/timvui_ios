//
//  SearchVC.m
//  TimVui
//
//  Created by Hoang The Hung on 5/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "SearchVC.h"

@interface SearchVC ()

@end

@implementation SearchVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark IBAction
-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ViewControllerDelegate
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Setup View and Table View
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _viewNavigation=[[UIView alloc] initWithFrame:CGRectMake(48,0, 320, 44)];
    [_viewNavigation setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_pattern_navigation"]]];
    UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 260, 30)];
    [imgView setImage:[UIImage imageNamed:@"img_search_bar_text"]];
    _tfdSearch=[[UITextField alloc] initWithFrame:CGRectMake(33, 10, 227, 30)];
    
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [_viewNavigation addSubview:imgView];
    [_viewNavigation addSubview:_tfdSearch];
    [self.navigationController.navigationBar  addSubview:_viewNavigation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_viewNavigation removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end
