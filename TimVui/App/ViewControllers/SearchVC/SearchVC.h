//
//  SearchVC.h
//  TimVui
//
//  Created by Hoang The Hung on 5/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVC : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) UITextField *tfdSearch;
@property (retain, nonatomic) UIView *viewNavigation;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnCity;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnDistrict;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnZone;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnCuisine;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPurpose;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnUlitility;
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
- (IBAction)buttonBackgroundClicked:(id)sender;
- (IBAction)buttonCityClicked:(id)sender;
- (IBAction)buttonDistrictClicked:(id)sender;
@end
