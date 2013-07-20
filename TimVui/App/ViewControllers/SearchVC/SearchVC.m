//
//  SearchVC.m
//  TimVui
//
//  Created by Hoang The Hung on 5/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "SearchVC.h"
#import "SearchWithArrayVC.h"
#import "NSDictionary+Extensions.h"
#import "TVAppDelegate.h"
#import "GlobalDataUser.h"
@interface SearchVC ()

@end

@implementation SearchVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //_dicPriceSearchParam=[[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark IBAction

-(void)categoryButtonClicked:(UIButton*)sender{
//    NSLog(@"%@",[GlobalDataUser sharedAccountClient].catArr);
    if ([sender isSelected]){
        [[GlobalDataUser sharedAccountClient].dicCatSearchParam removeObject:[[GlobalDataUser sharedAccountClient].catArr objectAtIndex:sender.tag] ];
        [sender setSelected:NO];
        
    }else{
        [[GlobalDataUser sharedAccountClient].dicCatSearchParam addObject:[[GlobalDataUser sharedAccountClient].catArr objectAtIndex:sender.tag] ];
        [sender setSelected:YES];
    }
    NSLog(@"%@",[GlobalDataUser sharedAccountClient].dicCatSearchParam);
}

-(void)priceButtonClicked:(UIButton*)sender{
    if ([sender isSelected]){
        [[GlobalDataUser sharedAccountClient].dicPriceSearchParam removeObject:[[GlobalDataUser sharedAccountClient].priceArr objectAtIndex:sender.tag]];
        [sender setSelected:NO];
        
    }else{
        [[GlobalDataUser sharedAccountClient].dicPriceSearchParam addObject:[[GlobalDataUser sharedAccountClient].priceArr objectAtIndex:sender.tag]];
        [sender setSelected:YES];
    }
    
//    NSLog(@"%@",[GlobalDataUser sharedAccountClient].dicPriceSearchParam);
}

- (IBAction)btnCancelSearchToolbarClicked:(id)sender {
    [_tfdSearch resignFirstResponder];
}

- (IBAction)btnSearchToolbarClicked:(id)sender {
    
    [_tfdSearch resignFirstResponder];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:_tfdSearch.text forKey:@"keyword"];
    [self prepareForSettingSearchWithParams:params];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonBackgroundClicked:(UIButton*)sender {
    [self.tfdSearch resignFirstResponder];
    [sender setUserInteractionEnabled:NO];
}

- (void)buttonCityClicked:(id)sender {
    
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:[SharedAppDelegate.getCityDistrictData valueForKey:@"data"]];
    [GlobalDataUser sharedAccountClient].currentSearchParam=kSearchParamCity;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonDistrictClicked:(id)sender {
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:[[GlobalDataUser sharedAccountClient].dicCitySearchParam valueForKey:@"districts"]];
    [GlobalDataUser sharedAccountClient].currentSearchParam=kSearchParamDistrict;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonZoneClicked:(id)sender {
    NSArray* myFilter = [self getZoneDataForSearching];
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:myFilter];
    [GlobalDataUser sharedAccountClient].currentSearchParam=kSearchParamZone;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonCuisineClicked:(id)sender {
    NSDictionary* params=[SharedAppDelegate getParamData];
    NSDictionary* dicCuisines=[[[params valueForKey:@"data"] valueForKey:@"mon-an"] valueForKey:@"params"];
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:[dicCuisines allValues]];
    [GlobalDataUser sharedAccountClient].currentSearchParam=kSearchParamCuisine;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (IBAction)buttonPurposeClicked:(id)sender {
    NSDictionary* params=[SharedAppDelegate getParamData];
    NSDictionary* dicCuisines=[[[params valueForKey:@"data"] valueForKey:@"muc-dich"] valueForKey:@"params"];
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:[dicCuisines allValues]];
    [GlobalDataUser sharedAccountClient].currentSearchParam=kSearchParamPurpose;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonUtilityClicked:(id)sender {
    NSDictionary* params=[SharedAppDelegate getParamData];
    NSDictionary* dicCuisines=[[[params valueForKey:@"data"] valueForKey:@"tien-ich"] valueForKey:@"params"];
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:[dicCuisines allValues]];
    NSLog(@"%@",[dicCuisines allValues]);
    [GlobalDataUser sharedAccountClient].currentSearchParam=kSearchParamUtilities;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)prepareForSettingSearchWithParams:(NSMutableDictionary *)params {
    CLLocationCoordinate2D location;
    
    [params setValue:kDistanceSearchMapDefault forKey:@"distance"];
    
    if ([GlobalDataUser sharedAccountClient].dicCitySearchParam) {
        [params setValue:[[GlobalDataUser sharedAccountClient].dicCitySearchParam valueForKey:@"alias"] forKey:@"city_alias"];
        location=[[GlobalDataUser sharedAccountClient].dicCitySearchParam safeLocationForKey:@"latlng"];
    }else{
        location=[GlobalDataUser sharedAccountClient].userLocation;
        if (location.latitude) {
            NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",location.latitude,location.longitude];
            [params setValue:strLatLng forKey:@"latlng"];
        }
        
        [params setValue:[[GlobalDataUser sharedAccountClient].dicCity valueForKey:@"alias"] forKey:@"city_alias"];
    }
    if ([GlobalDataUser sharedAccountClient].dicDistrictSearchParam&&[GlobalDataUser sharedAccountClient].dicDistrictSearchParam.count>0) {
        NSMutableArray*arr=[[NSMutableArray alloc] init];
        for (NSDictionary* dic in [GlobalDataUser sharedAccountClient].dicDistrictSearchParam) {
            NSLog(@"%@",dic);
            [arr addObject:[dic valueForKey:@"alias"]];
            
        }
        [params setValue:arr  forKey:@"district_aliases"];
    }
    if ([GlobalDataUser sharedAccountClient].dicPublicLocation)[params setValue:[[GlobalDataUser sharedAccountClient].dicPublicLocation valueForKey:@"alias"] forKey:@"public_location_aliases"];
    
    if ([_delegate respondsToSelector:@selector(didClickedOnButtonSearch:withLatlng:)]) {
        [_delegate didClickedOnButtonSearch:params withLatlng:location];
    }
}

- (IBAction)buttonSearchClicked:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [self prepareForSettingSearchWithParams:params];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonResetClicked:(id)sender {
    [GlobalDataUser sharedAccountClient].dicDistrictSearchParam=nil;
    [GlobalDataUser sharedAccountClient].dicPublicLocation=nil;
    [GlobalDataUser sharedAccountClient].dicCuisineSearchParam=nil;
    [GlobalDataUser sharedAccountClient].dicPurposeSearchParam=nil;
    [GlobalDataUser sharedAccountClient].dicUtilitiesSearchParam=nil;
    [[GlobalDataUser sharedAccountClient].dicPriceSearchParam removeAllObjects];
    [[GlobalDataUser sharedAccountClient].dicCatSearchParam removeAllObjects];
    
    [_btnPrice100 setSelected:NO];
    [_btnPrice1000 setSelected:NO];
    [_btnPrice100_200 setSelected:NO];
    [_btnPrice200_500 setSelected:NO];
    [_btnPrice500_1000 setSelected:NO];
    [_btnRestaurant setSelected:NO];
    [_btnCafe setSelected:NO];
    [_btnCakeShop setSelected:NO];
    [_btnEatingShop setSelected:NO];
    [_btnKaraoke setSelected:NO];
    [_btnBar setSelected:NO];
    [self settingForParamView];
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.btnBackgournd setUserInteractionEnabled:YES];
}

#pragma mark Helper
- (NSArray *)getZoneDataForSearching {
    NSArray *myFilter=nil;
    NSPredicate *filter =nil;
    if ([GlobalDataUser sharedAccountClient].dicCitySearchParam && [GlobalDataUser sharedAccountClient].dicDistrictSearchParam.count>0) {
        filter = [NSPredicate predicateWithFormat:@"(city_id == %@) AND (district_id == %@)",[[GlobalDataUser sharedAccountClient].dicCitySearchParam valueForKey:@"id"],[[[GlobalDataUser sharedAccountClient].dicDistrictSearchParam lastObject] valueForKey:@"id"]];
    }else if ([GlobalDataUser sharedAccountClient].dicCitySearchParam){
        filter = [NSPredicate predicateWithFormat:@"(city_id == %@)",[[GlobalDataUser sharedAccountClient].dicCitySearchParam valueForKey:@"id"]];
    }
    NSLog(@"%@",filter);
    if (filter) {
        NSArray* idPublicArr = [[SharedAppDelegate.getDistrictHasPublicLocationData valueForKey:@"data"] filteredArrayUsingPredicate:filter];
        NSLog(@"idPublicArr================/n%@",SharedAppDelegate.getDistrictHasPublicLocationData);
        NSMutableArray*arrIdStr=[[NSMutableArray alloc] init];
        for (NSDictionary*dic in idPublicArr) {
            [arrIdStr addObject:[dic valueForKey:@"public_location_id"]];
        }
        myFilter=[[SharedAppDelegate.getPublicLocationData valueForKey:@"data"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id IN %@",arrIdStr]];
    }
    return myFilter;
}

- (NSString *)getNameParamStringFrom:(NSArray *)arrValue withTitle:(NSString*)tempStrName{
    if (arrValue&&arrValue.count>0){
        BOOL isFirst=YES;
        for (NSString* str in [arrValue valueForKey:@"name"]) {
            if (isFirst) {
                isFirst=NO;
                tempStrName=[tempStrName stringByAppendingFormat:@"(%@",str];
            }else
                tempStrName=[tempStrName stringByAppendingFormat:@", %@",str];
        }
        tempStrName=[tempStrName stringByAppendingString:@")"];
        
    }
    return tempStrName;
}

- (void)settingForParamView {
    if ([GlobalDataUser sharedAccountClient].dicCitySearchParam)
        [_btnCity setTitle:[[GlobalDataUser sharedAccountClient].dicCitySearchParam valueForKey:@"name"] forState:UIControlStateNormal];
    else
        [_btnCity setTitle:@"Tỉnh/TP" forState:UIControlStateNormal];
    
    if ([GlobalDataUser sharedAccountClient].dicDistrictSearchParam.count>0){
        [_btnDistrict setTitle:([GlobalDataUser sharedAccountClient].dicDistrictSearchParam.count>1)?@"...":[[[GlobalDataUser sharedAccountClient].dicDistrictSearchParam lastObject] valueForKey:@"name"] forState:UIControlStateNormal];
        if ([_delegate respondsToSelector:@selector(didPickDistricts:)]) {
            [_delegate didPickDistricts:[GlobalDataUser sharedAccountClient].dicDistrictSearchParam];
        }
    }
    else
        [_btnDistrict setTitle:@"Quận/Huyện" forState:UIControlStateNormal];
    
    NSArray* zoneArr=[self getZoneDataForSearching];
    if (zoneArr.count>0) {
        [_lblZone setEnabled:YES];
        [_lblZone setAlpha:1.0];
        [_btnZone setEnabled:YES];
        [_btnZone setAlpha:1.0];
    }else{
        [_lblZone setEnabled:NO];
        [_lblZone setAlpha:.7];
        [_btnZone setEnabled:NO];
        [_btnZone setAlpha:.7];
    }
    _lblZone.text=[self getNameParamStringFrom:[GlobalDataUser sharedAccountClient].dicPublicLocation withTitle:@"Khu vực"];
    
    _lblCuisine.text=[self getNameParamStringFrom:[GlobalDataUser sharedAccountClient].dicCuisineSearchParam withTitle:@"Món ăn"];
    
    _lblPurpose.text=[self getNameParamStringFrom:[GlobalDataUser sharedAccountClient].dicPurposeSearchParam withTitle:@"Mục đích"];
    _lblUtilities.text=[self getNameParamStringFrom:[GlobalDataUser sharedAccountClient].dicUtilitiesSearchParam withTitle:@"Tiện ích"];
}

- (void)settingPriceCatButtons
{
    [_btnCity setBackgroundImage:[UIImage imageNamed:@"img_search_button_on"] forState:UIControlStateSelected];
    [_btnDistrict setBackgroundImage:[UIImage imageNamed:@"img_search_button_on"] forState:UIControlStateSelected];
    
    [_btnPrice100 setBackgroundImage:[UIImage imageNamed:@"img_search_price_on"] forState:UIControlStateSelected];
    [_btnPrice100_200 setBackgroundImage:[UIImage imageNamed:@"img_search_price_on"] forState:UIControlStateSelected];
    [_btnPrice200_500 setBackgroundImage:[UIImage imageNamed:@"img_search_price_on"] forState:UIControlStateSelected];
    [_btnPrice500_1000 setBackgroundImage:[UIImage imageNamed:@"img_search_price_on"] forState:UIControlStateSelected];
    [_btnPrice1000 setBackgroundImage:[UIImage imageNamed:@"img_search_price_on"] forState:UIControlStateSelected];
    
    [_btnSearch setBackgroundImage:[UIImage imageNamed:@"img_button_large_on"] forState:UIControlStateHighlighted];
    [_btnReset setBackgroundImage:[UIImage imageNamed:@"img_button_cancel_on"] forState:UIControlStateHighlighted];
    
    [_btnRestaurant setImage:[UIImage imageNamed:@"img_search_restaurant_off"] forState:UIControlStateSelected];
    [_btnCafe setImage:[UIImage imageNamed:@"img_search_cafe_on"] forState:UIControlStateSelected];
    [_btnCakeShop setImage:[UIImage imageNamed:@"img_search_cake_shop_on"] forState:UIControlStateSelected];
    [_btnEatingShop setImage:[UIImage imageNamed:@"img_search_eating_shop_on"] forState:UIControlStateSelected];
    [_btnKaraoke setImage:[UIImage imageNamed:@"img_search_karaoke_on"] forState:UIControlStateSelected];
    [_btnBar setImage:[UIImage imageNamed:@"img_search_club_on"] forState:UIControlStateSelected];
    
    [_btnCity setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_btnCity setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_btnDistrict setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_btnDistrict setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [_btnPrice100 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_btnPrice1000 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_btnPrice100_200 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_btnPrice200_500 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_btnPrice500_1000 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    [_btnPrice100 addTarget:self action:@selector(priceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnPrice100_200 addTarget:self action:@selector(priceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnPrice200_500 addTarget:self action:@selector(priceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnPrice500_1000 addTarget:self action:@selector(priceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnPrice1000 addTarget:self action:@selector(priceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //Set title for button Prices
    if (![GlobalDataUser sharedAccountClient].priceArr) {
        [GlobalDataUser sharedAccountClient].priceArr=[[SharedAppDelegate.getPriceAvgData valueForKey:@"data"] allValues];
        NSLog(@"%@",[GlobalDataUser sharedAccountClient].priceArr);
    }
    
    [_btnPrice100 setTitle:[[[GlobalDataUser sharedAccountClient].priceArr objectAtIndex:1] valueForKey:@"name"] forState:UIControlStateNormal];
    
    [_btnPrice100_200 setTitle:[[[GlobalDataUser sharedAccountClient].priceArr objectAtIndex:3] valueForKey:@"name"] forState:UIControlStateNormal];
    
    [_btnPrice200_500 setTitle:[[[GlobalDataUser sharedAccountClient].priceArr objectAtIndex:4] valueForKey:@"name"] forState:UIControlStateNormal];
    
    [_btnPrice500_1000 setTitle:[[[GlobalDataUser sharedAccountClient].priceArr objectAtIndex:2] valueForKey:@"name"] forState:UIControlStateNormal];
    
    [_btnPrice1000 setTitle:[[[GlobalDataUser sharedAccountClient].priceArr objectAtIndex:0] valueForKey:@"name"] forState:UIControlStateNormal];
    _btnPrice1000.tag=0;
    [_btnPrice100 setTag:1];
    _btnPrice100_200.tag=3;
    _btnPrice200_500.tag=4;
    _btnPrice500_1000.tag=2;
    
    
    
    //Set value for button category
    if (![GlobalDataUser sharedAccountClient].catArr) {
        [GlobalDataUser sharedAccountClient].catArr=[SharedAppDelegate.getCatData valueForKey:@"data"] ;
        NSLog(@"%@",[GlobalDataUser sharedAccountClient].catArr);
    }
    
    [_btnRestaurant addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnRestaurant.tag=0;
    [_btnCafe addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnCafe.tag=1;
    [_btnCakeShop addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnCakeShop.tag=3;
    [_btnEatingShop addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnEatingShop.tag  =2;
    [_btnKaraoke addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnKaraoke.tag=5;
    [_btnBar addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnBar.tag=4;
    
    for (int i=0; i<[GlobalDataUser sharedAccountClient].priceArr.count; i++) {
        NSDictionary* dic=[[GlobalDataUser sharedAccountClient].priceArr objectAtIndex:i];
        if ([[GlobalDataUser sharedAccountClient].dicPriceSearchParam containsObject:dic]) {
            switch (i) {
                case 0:
                    [_btnPrice1000 setSelected:YES];
                    break;
                case 1:
                    [_btnPrice100 setSelected:YES];
                    break;
                case 2:
                    [_btnPrice500_1000 setSelected:YES];
                    break;
                case 3:
                    [_btnPrice100_200 setSelected:YES];
                    break;
                case 4:
                    [_btnPrice200_500 setSelected:YES];
                    break;
                default:
                    break;
            }
        }
    }
    for (int i=0; i<[GlobalDataUser sharedAccountClient].catArr.count; i++) {
        NSDictionary* dic=[[GlobalDataUser sharedAccountClient].catArr objectAtIndex:i];
        if ([[GlobalDataUser sharedAccountClient].dicCatSearchParam containsObject:dic]) {
            switch (i) {
                case 0:
                    [_btnRestaurant setSelected:YES];
                    break;
                case 1:
                    [_btnEatingShop setSelected:YES];
                    break;
                case 2:
                    [_btnCafe setSelected:YES];
                    break;
                case 3:
                    [_btnCakeShop setSelected:YES];
                    break;
                case 4:
                    [_btnBar setSelected:YES];
                    break;
                default:
                    break;
            }
        }
    }

    
}
#pragma mark ViewControllerDelegate
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tfdSearch setDelegate:self];
    [self.btnBackgournd setUserInteractionEnabled:NO];
    
    NSLog(@"%@",[GlobalDataUser sharedAccountClient].dicCitySearchParam);
    if (![GlobalDataUser sharedAccountClient].dicCitySearchParam) {
        NSString* idStr=[[GlobalDataUser sharedAccountClient].dicCity valueForKey:@"alias"];
        //    NSLog(@"%@",idStr);
        //    NSLog(@"%@",[SharedAppDelegate.getCityDistrictData valueForKey:@"data"] );
        NSPredicate* filter = [NSPredicate predicateWithFormat:@"(alias == %@)",idStr];
        NSArray* idPublicArr = [[SharedAppDelegate.getCityDistrictData valueForKey:@"data"] filteredArrayUsingPredicate:filter];
        [GlobalDataUser sharedAccountClient].dicCitySearchParam=[idPublicArr lastObject];
    }
   
//    NSLog(@"%@",self.dicCitySearchParam);
    // Do any additional setup after loading the view from its nib.
    // Setup View and Table View
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnCity = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [_btnCity setBackgroundImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [_btnCity addTarget:self action:@selector(buttonCityClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_viewNavigation addSubview:_btnCity];
    
    _viewNavigation=[[UIView alloc] initWithFrame:CGRectMake(48,0, 320, 44)];
    [_viewNavigation setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_pattern_navigation"]]];
    UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 260, 30)];
    [imgView setImage:[UIImage imageNamed:@"img_search_bar_text"]];
    _tfdSearch=[[UITextField alloc] initWithFrame:CGRectMake(33, 10, 227, 30)];
    [_tfdSearch setDelegate:self];
    _tfdSearch.inputAccessoryView=_tbrAccessorySearch;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [_viewNavigation addSubview:imgView];
    [_viewNavigation addSubview:_tfdSearch];
    
    
    //
    self.view.backgroundColor = [UIColor colorWithRed:(236/255.0f) green:(236/255.0f) blue:(236/255.0f) alpha:1.0f];
    [self settingPriceCatButtons];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar  addSubview:_viewNavigation];
    [self settingForParamView];
    
    
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
    [self setLblZone:nil];
    [self setLblCuisine:nil];
    [self setLblPurpose:nil];
    [self setLblUtilities:nil];
    [self setTbrAccessorySearch:nil];
    [super viewDidUnload];
}

@end
