//
//  MyViewController.m
//  Anuong
//
//  Created by Hoang The Hung on 10/16/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "MyViewController.h"
#import "Utilities.h"
#import "TVAppDelegate.h"
#import "TSMessage.h"
@interface MyViewController ()

@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString* strAlarm=@"Không có kết nối internet!";
    if (![SharedAppDelegate isConnected]) {
        [TSMessage showNotificationInViewController:self
                                          withTitle:strAlarm
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeError];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIBarButtonItem *)toggleBarButtonItem {
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-off"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-on"] forState:UIControlStateHighlighted];
    
    //[backButton addTarget:self.viewDeckController action:@selector(toggleDownLeftView) forControlEvents:UIControlEventTouchDown];
    
    [backButton addTarget:self action:@selector(toggleTopView) forControlEvents:UIControlEventTouchUpInside];
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, 16, -0);
    }else{
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, 0, -0);
    }
    [backButtonView addSubview:backButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    item.accessibilityLabel = NSLocalizedString(@"Menu", nil);
    item.accessibilityHint = NSLocalizedString(@"Double-tap to reveal menu on the left. If you need to close the menu without choosing its item, find the menu button in top-right corner (slightly to the left) and double-tap it again.", nil);
    return item;
}


- (UIBarButtonItem *)backBarButtonItem {
    
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, 16, -0);
    }else{
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, 0, -0);
    }
    
    [backButtonView addSubview:backButton];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    return backButtonItem;
    /*
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    backButtonView.bounds = CGRectOffset(backButtonView.bounds, 10, 0);
    [backButtonView addSubview:backButton];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    */
}

- (UIBarButtonItem *)searchButtonItem{
    UIButton* _btnSearchBar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_search_bar_off"] forState:UIControlStateNormal];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_search_bar_on"] forState:UIControlStateHighlighted];
    [_btnSearchBar addTarget:self action:@selector(searchBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, -16, -2);
    }else{
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, -5, -2);
    }
    
    [backButtonView addSubview:_btnSearchBar];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    return searchButtonItem;
}




-(UIBarButtonItem*)handbookFilterButton{
    UIButton* _btnSearchBar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_handbook_filter_off"] forState:UIControlStateNormal];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_handbook_filter_on"] forState:UIControlStateHighlighted];
    [_btnSearchBar addTarget:self action:@selector(filterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, -16, -0);
    }else{
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, -5, -0);
    }
    
    [backButtonView addSubview:_btnSearchBar];
    UIBarButtonItem *handbookFilterButton = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    return handbookFilterButton;
}

-(UIBarButtonItem*)barButtonWithTitle:(NSString*)strTitle{
    UIButton* doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    
    [doneButton setBackgroundImage:[Utilities imageFromColor:kDeepOrangeColor] forState:UIControlStateNormal];
    
    [doneButton setBackgroundImage:[Utilities imageFromColor:kOrangeColor] forState:UIControlStateHighlighted];
    
    [doneButton setTitle:strTitle forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, -16, -0);
    }else{
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, -5, -0);
    }
    
    [backButtonView addSubview:doneButton];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    return doneButtonItem;
}


@end
