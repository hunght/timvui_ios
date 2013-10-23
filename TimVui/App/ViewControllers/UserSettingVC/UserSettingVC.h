//
//  UserSettingVC.h
//  Anuong
//
//  Created by Hoang The Hung on 8/31/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSettingVC : MyViewController
@property (weak, nonatomic) IBOutlet UIView *SuggestView;
@property (weak, nonatomic) IBOutlet UIView *VibrateView;
@property (weak, nonatomic) IBOutlet UISwitch *swVirate;
@property (weak, nonatomic) IBOutlet UISwitch *swFavoriteCoupon;
@property (weak, nonatomic) IBOutlet UISwitch *swNearbyBranchCoupon;
@property (weak, nonatomic) IBOutlet UISwitch *swSuggestImHere;
- (IBAction)swSuggestImHereChangedValue:(id)sender;
- (IBAction)swNearbyBranchCouponChangedValue:(id)sender;
- (IBAction)swFaveriteBranchCouponChangedValue:(id)sender;
- (IBAction)swVibrateChangedValue:(id)sender;

@end
