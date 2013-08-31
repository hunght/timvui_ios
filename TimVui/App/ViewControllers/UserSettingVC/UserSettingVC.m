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
-(void)detaultButtonClicked:(id)s{

}

-(void)saveButtonClicked:(id)s{

}

- (IBAction)swSuggestImHereChangedValue:(id)sender {
}

- (IBAction)swNearbyBranchCouponChangedValue:(id)sender {
}

- (IBAction)swFaveriteBranchCouponChangedValue:(id)sender {
}

- (IBAction)swVibrateChangedValue:(id)sender {
}
@end
