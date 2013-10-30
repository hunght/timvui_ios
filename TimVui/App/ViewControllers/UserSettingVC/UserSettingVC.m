//
//  UserSettingVC.m
//  Anuong
//
//  Created by Hoang The Hung on 8/31/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "UserSettingVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"
#import "GlobalDataUser.h"
#import "TVNetworkingClient.h"
#import "TSMessage.h"
#import "LoginVC.h"
#import <JSONKit.h>
@interface UserSettingVC ()

@end

@implementation UserSettingVC

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
    
    [[GlobalDataUser sharedAccountClient] getSettingNotificationUser];

    [self updateValueForSwitch];
    CALayer* l=    _SuggestView.layer;
    [l setMasksToBounds:YES];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    l=    _VibrateView.layer;
    [l setMasksToBounds:YES];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    int height=_VibrateView.frame.origin.y+_VibrateView.frame.size.height+10;
    UIButton* _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(5, height, 153, 34)];
    [_saveButton setTitle:@"LƯU LẠI" forState:UIControlStateNormal];
    _saveButton.titleLabel.font=[UIFont fontWithName:@"UVNTinTucHepThemBold" size:(20)];
    [_saveButton setBackgroundImage:[Utilities imageFromColor:kCyanGreenColor] forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[Utilities imageFromColor:kPaleCyanGreenColor] forState:UIControlStateSelected];
    [_saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.autoresizingMask           = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_saveButton];
    UIButton*_detailButton = [[UIButton alloc] initWithFrame:CGRectMake(150+13, height, 152, 34)];
    [_detailButton setTitle:@"MẶC ĐỊNH" forState:UIControlStateNormal];
    [_detailButton setBackgroundImage:[Utilities imageFromColor:kCyanGreenColor] forState:UIControlStateNormal];
    _detailButton.titleLabel.font= [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(20)];
    [_detailButton setBackgroundImage:[Utilities imageFromColor:kPaleCyanGreenColor] forState:UIControlStateSelected];
    [_detailButton addTarget:self action:@selector(detaultButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _detailButton.autoresizingMask           = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_detailButton];
    // Do any additional setup after loading the view from its nib.
    if (![GlobalDataUser sharedAccountClient].isLogin) {
        [self.swFavoriteCoupon setOn:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSuggestView:nil];
    [self setVibrateView:nil];
    [self setSwVirate:nil];
    [self setSwFavoriteCoupon:nil];
    [self setSwNearbyBranchCoupon:nil];
    [self setSwSuggestImHere:nil];
    [super viewDidUnload];
}

#pragma mark IBAction
- (void)updateValueForSwitch {
    
    [_swFavoriteCoupon setOn:[GlobalDataUser sharedAccountClient].isFollowBranchesHasNewCouponYES.boolValue];
    [_swNearbyBranchCoupon setOn:[GlobalDataUser sharedAccountClient].isNearlyBranchesHasNewCouponYES.boolValue];
    [_swSuggestImHere setOn:[GlobalDataUser sharedAccountClient].isHasNearlyBranchesYES.boolValue];
    [_swVirate setOn:[GlobalDataUser sharedAccountClient].isWantToOnVirateYES.boolValue];
    
}

-(void)detaultButtonClicked:(id)s{
    [GlobalDataUser sharedAccountClient].isNearlyBranchesHasNewCouponYES=[NSNumber numberWithBool:YES];
    [GlobalDataUser sharedAccountClient].isWantToOnVirateYES=[NSNumber numberWithBool:YES];
    [GlobalDataUser sharedAccountClient].isHasNearlyBranchesYES=[NSNumber numberWithBool:YES];
    
    if ([GlobalDataUser sharedAccountClient].isLogin) {
        [GlobalDataUser sharedAccountClient].isFollowBranchesHasNewCouponYES=[NSNumber numberWithBool:YES];
        [self saveUserSettingNotification];
    }
    
    [[GlobalDataUser sharedAccountClient] setSettingNotificationUser];
    [self updateValueForSwitch];

}

- (void)saveUserSettingNotification {
    if (![GlobalDataUser sharedAccountClient].deviceToken) {
        [self.swFavoriteCoupon setOn:NO];
        return;
    }
    NSLog(@"_deviceToken = %@",[GlobalDataUser sharedAccountClient].deviceToken);
    NSString* isON=([GlobalDataUser sharedAccountClient].isFollowBranchesHasNewCouponYES.boolValue)?@"1":@"0";
    NSDictionary * userObject=[NSDictionary dictionaryWithObjectsAndKeys:
                               @"IOS",@"mobile_os",
                               isON,@"is_notify",
                               [GlobalDataUser sharedAccountClient].UUID,@"mobile_id",
                               [GlobalDataUser sharedAccountClient].deviceToken ,@"mobile_token",
                               [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                               nil];
    
    NSDictionary *paramsHandBook = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [userObject JSONString],@"UserMobile" ,
                                    nil];
    
    NSLog(@"paramsHandBook = %@",paramsHandBook);
    
    [[TVNetworkingClient sharedClient] postPath:@"user/userMobileSave" parameters:paramsHandBook success:^(AFHTTPRequestOperation *operation, id JSON) {
        [[GlobalDataUser sharedAccountClient] setSettingNotificationUser];
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Cập nhật thành công"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeSuccess];
        
        [self dismissModalViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        [GlobalDataUser sharedAccountClient].isFollowBranchesHasNewCouponYES=[NSNumber numberWithBool:NO];
        [self.swFavoriteCoupon setOn:NO];
        [[GlobalDataUser sharedAccountClient] setSettingNotificationUser];
        
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Cập nhật thất bại"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeError];
    }];
}

-(void)saveButtonClicked:(id)s{
    if ([GlobalDataUser sharedAccountClient].isLogin) {
        [self saveUserSettingNotification];
    }
}

- (IBAction)swSuggestImHereChangedValue:(UISwitch*)sender {
    [GlobalDataUser sharedAccountClient].isHasNearlyBranchesYES=[NSNumber numberWithBool:sender.isOn];
}

- (IBAction)swNearbyBranchCouponChangedValue:(UISwitch*)sender {
    [GlobalDataUser sharedAccountClient].isNearlyBranchesHasNewCouponYES=[NSNumber numberWithBool:sender.isOn];
}

- (IBAction)swFaveriteBranchCouponChangedValue:(UISwitch*)sender {
    if ([GlobalDataUser sharedAccountClient].isLogin) {
        [GlobalDataUser sharedAccountClient].isFollowBranchesHasNewCouponYES=[NSNumber numberWithBool:sender.isOn];
    }else{
        LoginVC* loginVC=nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
        } else {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
        }
        
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentModalViewController:navController animated:YES];
        
        [loginVC goWithDidLogin:^{
            [GlobalDataUser sharedAccountClient].isFollowBranchesHasNewCouponYES=[NSNumber numberWithBool:sender.isOn];
        } thenLoginFail:^{
            [sender setOn:NO];
            [GlobalDataUser sharedAccountClient].isFollowBranchesHasNewCouponYES=[NSNumber numberWithBool:sender.isOn];
        }];
    }
}

- (IBAction)swVibrateChangedValue:(UISwitch*)sender {
    [GlobalDataUser sharedAccountClient].isWantToOnVirateYES=[NSNumber numberWithBool:sender.isOn];
}

@end
