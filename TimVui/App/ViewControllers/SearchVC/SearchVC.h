//
//  SearchVC.h
//  TimVui
//
//  Created by Hoang The Hung on 5/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@protocol SearchVCDelegate
/**
 * Sent to the delegate when sign up has completed successfully. Immediately
 * followed by an invocation of userDidLogin:
 */
-(void)didClickedOnButtonSearch:(NSMutableDictionary *)params withLatlng:(CLLocationCoordinate2D)latlng;
-(void)didPickDistricts:(NSArray*)arrDics;

@end
@interface SearchVC : MyViewController<UITextFieldDelegate>
@property (nonatomic, retain) NSObject<SearchVCDelegate>* delegate;
@property (retain, nonatomic) UITextField *tfdSearch;
@property (retain, nonatomic) UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UISwitch *switchUserLocation;
@property (retain, nonatomic) UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UIView *viewSlide;

@property (weak, nonatomic) IBOutlet UILabel *lblRestaurant;
@property (weak, nonatomic) IBOutlet UILabel *lblEatingShop;
@property (weak, nonatomic) IBOutlet UILabel *lblCafeKem;
@property (weak, nonatomic) IBOutlet UILabel *lblKaraoke;
@property (weak, nonatomic) IBOutlet UILabel *lblCakeShop;
@property (weak, nonatomic) IBOutlet UILabel *lblBarPub;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnDistrict;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnZone;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnCuisine;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPurpose;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPrice100;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPrice100_200;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPrice200_500;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPrice500_1000;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPrice1000;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnRestaurant;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnCafe;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnKaraoke;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnEatingShop;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnCakeShop;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnBar;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSearch;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnReset;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnBackgournd;
@property (strong, nonatomic) IBOutlet UIToolbar *tbrAccessorySearch;



@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblZone;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblCuisine;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblPurpose;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblDictricts;
- (IBAction)btnCancelSearchToolbarClicked:(id)sender;
- (IBAction)btnSearchToolbarClicked:(id)sender;
- (IBAction)swithChagedValue:(id)sender;
- (IBAction)buttonBackgroundClicked:(id)sender;
- (IBAction)buttonCityClicked:(id)sender;
- (IBAction)buttonDistrictClicked:(id)sender;
- (IBAction)buttonZoneClicked:(id)sender;
- (IBAction)buttonCuisineClicked:(id)sender;
- (IBAction)buttonPurposeClicked:(id)sender;
- (IBAction)buttonUtilityClicked:(id)sender;
- (IBAction)buttonSearchClicked:(id)sender;
- (IBAction)buttonResetClicked:(id)sender;


@end
