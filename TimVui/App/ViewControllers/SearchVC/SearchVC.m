//
//  SearchVC.m
//  TimVui
//
//  Created by Hoang The Hung on 5/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "SearchVC.h"
#import "SearchDistrictsVC.h"
#import "SearchCitiesVC.h"
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
- (IBAction)buttonBackgroundClicked:(id)sender {
    [self.tfdSearch resignFirstResponder];
}

- (IBAction)buttonCityClicked:(id)sender {
    SearchCitiesVC *viewController = [[SearchCitiesVC alloc] initWithSectionIndexes:YES];
    viewController.searchVC=self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonDistrictClicked:(id)sender {
    SearchDistrictsVC *viewController = [[SearchDistrictsVC alloc] initWithSectionIndexes:YES withParam:[_dicCitySearchParam valueForKey:@"districts"]];
    viewController.searchVC=self;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.btnBackgournd setEnabled:YES];
    
}

#pragma mark ViewControllerDelegate
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tfdSearch setDelegate:self];
    [self.btnBackgournd setEnabled:NO];
    
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
    
    //
    self.view.backgroundColor = [UIColor colorWithRed:(236/255.0f) green:(236/255.0f) blue:(236/255.0f) alpha:1.0f];
    
    [_btnCity setBackgroundImage:[UIImage imageNamed:@"img_search_button_on"] forState:UIControlStateHighlighted];
    [_btnDistrict setBackgroundImage:[UIImage imageNamed:@"img_search_button_on"] forState:UIControlStateHighlighted];
    
    [_btnPrice100 setBackgroundImage:[UIImage imageNamed:@"img_search_price_on"] forState:UIControlStateHighlighted];
    [_btnPrice100_200 setBackgroundImage:[UIImage imageNamed:@"img_search_price_on"] forState:UIControlStateHighlighted];
    [_btnPrice200_500 setBackgroundImage:[UIImage imageNamed:@"img_search_price_on"] forState:UIControlStateHighlighted];
    [_btnPrice500_1000 setBackgroundImage:[UIImage imageNamed:@"img_search_price_on"] forState:UIControlStateHighlighted];
    [_btnPrice1000 setBackgroundImage:[UIImage imageNamed:@"img_search_price_on"] forState:UIControlStateHighlighted];
    
    [_btnSearch setBackgroundImage:[UIImage imageNamed:@"img_button_large_on"] forState:UIControlStateHighlighted];
    [_btnReset setBackgroundImage:[UIImage imageNamed:@"img_button_cancel_on"] forState:UIControlStateHighlighted];
    
    [_btnRestaurant setImage:[UIImage imageNamed:@"img_search_restaurant_off"] forState:UIControlStateHighlighted];
    [_btnCafe setImage:[UIImage imageNamed:@"img_search_cafe_on"] forState:UIControlStateHighlighted];
    [_btnCakeShop setImage:[UIImage imageNamed:@"img_search_cake_shop_on"] forState:UIControlStateHighlighted];
    [_btnEatingShop setImage:[UIImage imageNamed:@"img_search_eating_shop_on"] forState:UIControlStateHighlighted];
    [_btnKaraoke setImage:[UIImage imageNamed:@"img_search_karaoke_on"] forState:UIControlStateHighlighted];
    [_btnBar setImage:[UIImage imageNamed:@"img_search_club_on"] forState:UIControlStateHighlighted];
    
    [_btnCity setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_btnCity setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_btnDistrict setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_btnDistrict setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [_btnPrice100 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_btnPrice1000 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_btnPrice100_200 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_btnPrice200_500 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_btnPrice500_1000 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (_dicCitySearchParam)
        [_btnCity setTitle:[_dicCitySearchParam valueForKey:@"name"] forState:UIControlStateNormal];
    else
        [_btnCity setTitle:@"Tỉnh/TP" forState:UIControlStateNormal];
    
    if (_dicDistrictSearchParam) 
        [_btnDistrict setTitle:[_dicDistrictSearchParam valueForKey:@"name"] forState:UIControlStateNormal];
    else
        [_btnDistrict setTitle:@"Quận/Huyện" forState:UIControlStateNormal];
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
    
    [self setBtnCity:nil];
    [self setBtnDistrict:nil];
    [self setBtnZone:nil];
    [self setBtnCuisine:nil];
    [self setBtnPurpose:nil];
    [self setBtnUlitility:nil];
    [self setBtnPrice100:nil];
    [self setBtnPrice100_200:nil];
    [self setBtnPrice200_500:nil];
    [self setBtnPrice500_1000:nil];
    [self setBtnPrice1000:nil];
    [self setBtnRestaurant:nil];
    [self setBtnCafe:nil];
    [self setBtnKaraoke:nil];
    [self setBtnEatingShop:nil];
    [self setBtnCakeShop:nil];
    [self setBtnBar:nil];
    [self setBtnSearch:nil];
    [self setBtnReset:nil];
    [self setBtnBackgournd:nil];
    [super viewDidUnload];
}

@end
