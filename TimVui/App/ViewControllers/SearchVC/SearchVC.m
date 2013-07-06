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
@property (retain,nonatomic) NSArray* priceArr;
@property (retain,nonatomic) NSArray* catArr;
@end

@implementation SearchVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dicCatSearchParam=[[NSMutableArray alloc] init];
        //_dicPriceSearchParam=[[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark IBAction
-(void)categoryButtonClicked:(UIButton*)sender{
    [sender setSelected:YES];
    NSLog(@"%d",sender.tag);
    [_dicCatSearchParam addObject:[[_catArr objectAtIndex:sender.tag] valueForKey:@"alias"]];
}
-(void)priceButtonClicked:(UIButton*)sender{
    [sender setSelected:YES];
//    [_dicPriceSearchParam addObject:[[_priceArr objectAtIndex:sender.tag] allValues]];
    _dicPriceSearchParam=[_priceArr objectAtIndex:sender.tag];
}
- (IBAction)buttonBackgroundClicked:(id)sender {
    [self.tfdSearch resignFirstResponder];
}

- (IBAction)buttonCityClicked:(id)sender {
    
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:[SharedAppDelegate.getCityDistrictData valueForKey:@"data"]];
    viewController.searchVC=self;
    self.currentSearchParam=kSearchParamCity;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonDistrictClicked:(id)sender {
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:[_dicCitySearchParam valueForKey:@"districts"]];
    NSLog(@"%@",self.dicCitySearchParam);
    viewController.searchVC=self;
    _currentSearchParam=kSearchParamDistrict;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonZoneClicked:(id)sender {
    NSPredicate *filter =nil;
    if (_dicCitySearchParam && _dicDistrictSearchParam.count>0) {
        filter = [NSPredicate predicateWithFormat:@"(city_id == %@) AND (district_id == %@)",[_dicCitySearchParam valueForKey:@"id"],[[_dicDistrictSearchParam lastObject] valueForKey:@"id"]];
    }else if (_dicCitySearchParam){
        filter = [NSPredicate predicateWithFormat:@"(city_id == %@)",[_dicCitySearchParam valueForKey:@"id"]];
    }
    NSArray* myFilter=nil;
    if (filter) {
        NSArray* idPublicArr = [[SharedAppDelegate.getDistrictHasPublicLocationData valueForKey:@"data"] filteredArrayUsingPredicate:filter];
        NSLog(@"%@",idPublicArr);
        NSMutableArray*arrIdStr=[[NSMutableArray alloc] init];
        for (NSDictionary*dic in idPublicArr) {
            [arrIdStr addObject:[dic valueForKey:@"public_location_id"]];
        }
        myFilter=[[SharedAppDelegate.getPublicLocationData valueForKey:@"data"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id IN %@",arrIdStr]];
    }
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:myFilter];
    viewController.searchVC=self;
    _currentSearchParam=kSearchParamZone;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonCuisineClicked:(id)sender {
    NSDictionary* params=[SharedAppDelegate getParamData];
    NSDictionary* dicCuisines=[[[params valueForKey:@"data"] valueForKey:@"mon-an"] valueForKey:@"params"];
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:[dicCuisines allValues]];
    viewController.searchVC=self;
    _currentSearchParam=kSearchParamCuisine;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (IBAction)buttonPurposeClicked:(id)sender {
    NSDictionary* params=[SharedAppDelegate getParamData];
    NSDictionary* dicCuisines=[[[params valueForKey:@"data"] valueForKey:@"muc-dich"] valueForKey:@"params"];
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:[dicCuisines allValues]];
    viewController.searchVC=self;
    _currentSearchParam=kSearchParamPurpose;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonUtilityClicked:(id)sender {
    NSDictionary* params=[SharedAppDelegate getParamData];
    NSDictionary* dicCuisines=[[[params valueForKey:@"data"] valueForKey:@"tien-ich"] valueForKey:@"params"];
    SearchWithArrayVC *viewController = [[SearchWithArrayVC alloc] initWithSectionIndexes:YES withParam:[dicCuisines allValues]];
    viewController.searchVC=self;
    _currentSearchParam=kSearchParamUtilities;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonSearchClicked:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    CLLocationCoordinate2D location;
    
    [params setValue:kDistanceSearchMapDefault forKey:@"distance"];
    
    if (_dicCitySearchParam) {
        [params setValue:[_dicCitySearchParam valueForKey:@"alias"] forKey:@"city_alias"];
        location=[_dicCitySearchParam safeLocationForKey:@"latlng"];
    }else{
        location=[GlobalDataUser sharedAccountClient].userLocation;
        if (location.latitude) {
            NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",location.latitude,location.longitude];
            [params setValue:strLatLng forKey:@"latlng"];
        }
        
        [params setValue:[[GlobalDataUser sharedAccountClient].dicCity valueForKey:@"alias"] forKey:@"city_alias"];
    }
    
    if (_dicCatSearchParam.count>0) {
        [params setValue:_dicCatSearchParam  forKey:@"cat_aliases"];
    }
     NSLog(@"%@",_dicCatSearchParam);
    if (_dicPriceSearchParam) {
        [params setValue:_dicPriceSearchParam  forKey:@"prices"];
    }
    
    if (_dicDistrictSearchParam&&_dicDistrictSearchParam.count>0) {
        NSMutableArray*arr=[[NSMutableArray alloc] init];
        for (NSDictionary* dic in _dicDistrictSearchParam) {
            NSLog(@"%@",dic);
            [arr addObject:[dic valueForKey:@"alias"]];
            
        }
        [params setValue:arr  forKey:@"district_aliases"];
    }   
     NSLog(@"%@",params);
    if ([_delegate respondsToSelector:@selector(didClickedOnButtonSearch:withLatlng:)]) {
        [_delegate didClickedOnButtonSearch:params withLatlng:location];
    }

    [self.navigationController popViewControllerAnimated:YES];
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
    NSString* idStr=[[GlobalDataUser sharedAccountClient].dicCity valueForKey:@"alias"];
//    NSLog(@"%@",idStr);
//    NSLog(@"%@",[SharedAppDelegate.getCityDistrictData valueForKey:@"data"] );
    NSPredicate* filter = [NSPredicate predicateWithFormat:@"(alias == %@)",idStr];
    NSArray* idPublicArr = [[SharedAppDelegate.getCityDistrictData valueForKey:@"data"] filteredArrayUsingPredicate:filter];
    self.dicCitySearchParam=[idPublicArr lastObject];
//    NSLog(@"%@",self.dicCitySearchParam);
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
    _priceArr=[[SharedAppDelegate.getPriceAvgData valueForKey:@"data"] allValues];
    [_btnPrice100 setTitle:[[_priceArr objectAtIndex:1] valueForKey:@"name"] forState:UIControlStateNormal];
    
    [_btnPrice100_200 setTitle:[[_priceArr objectAtIndex:3] valueForKey:@"name"] forState:UIControlStateNormal];
    
    [_btnPrice200_500 setTitle:[[_priceArr objectAtIndex:4] valueForKey:@"name"] forState:UIControlStateNormal];
    
    [_btnPrice500_1000 setTitle:[[_priceArr objectAtIndex:2] valueForKey:@"name"] forState:UIControlStateNormal];
   
    [_btnPrice1000 setTitle:[[_priceArr objectAtIndex:0] valueForKey:@"name"] forState:UIControlStateNormal];
    _btnPrice1000.tag=0;
    [_btnPrice100 setTag:1];
    _btnPrice100_200.tag=3;
    _btnPrice200_500.tag=4;
    _btnPrice500_1000.tag=2;
    //Set value for button category
    _catArr=[SharedAppDelegate.getCatData valueForKey:@"data"] ;
    NSLog(@"%@",_catArr);
    [_btnRestaurant addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnRestaurant.tag=0;
    [_btnCafe addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnCafe.tag=2;
    [_btnCakeShop addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnCakeShop.tag=3;
    [_btnEatingShop addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnEatingShop.tag  =1;
    [_btnKaraoke addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnKaraoke.tag=5;
    [_btnBar addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnBar.tag=4;
}

-(void)viewWillAppear:(BOOL)animated{
    [_btnPrice100 setTag:1];
    if (_dicCitySearchParam)
        [_btnCity setTitle:[_dicCitySearchParam valueForKey:@"name"] forState:UIControlStateNormal];
    else
        [_btnCity setTitle:@"Tỉnh/TP" forState:UIControlStateNormal];
    

    
    if (_dicDistrictSearchParam.count>0){
        [_btnDistrict setTitle:(_dicDistrictSearchParam.count>1)?@"...":[[_dicDistrictSearchParam lastObject] valueForKey:@"name"] forState:UIControlStateNormal];
        if ([_delegate respondsToSelector:@selector(didPickDistricts:)]) {
            [_delegate didPickDistricts:_dicDistrictSearchParam];
        }
    }
    else
        [_btnDistrict setTitle:@"Quận/Huyện" forState:UIControlStateNormal];
    
    if (_dicPublicLocation){
        NSString* tempStrName=@"Khu vực( ";
        for (NSString* str in [_dicPublicLocation valueForKey:@"name"]) {
            tempStrName=[tempStrName stringByAppendingString:str];
        }
        tempStrName=[tempStrName stringByAppendingString:@")"];
        _lblZone.text=tempStrName;
    }
    else
        _lblZone.text=@"Khu vực";
    
    if (_dicCuisineSearchParam)
        _lblCuisine.text=[NSString stringWithFormat:@"Món ăn (%@)",[_dicCuisineSearchParam valueForKey:@"name"]];
    else
        _lblCuisine.text=@"Món ăn";
    
    if (_dicPurposeSearchParam)
        _lblPurpose.text=[NSString stringWithFormat:@"Mục đích (%@)",[_dicPurposeSearchParam valueForKey:@"name"]];
    else
        _lblPurpose.text=@"Mục đích";
    
    if (_dicUtilitiesSearchParam)
        _lblUtilities.text=[NSString stringWithFormat:@"Tiện ích (%@)",[_dicUtilitiesSearchParam valueForKey:@"name"]];
    else
        _lblUtilities.text=@"Tiện ích";
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
    [super viewDidUnload];
}

@end
