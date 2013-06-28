//
//  BranchProfileVC.m
//  TimVui
//
//  Created by Hoang The Hung on 6/5/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "SpecBranchProfileVC.h"
#import "TVAppDelegate.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "GlobalDataUser.h"
#import <QuartzCore/QuartzCore.h>
#import "TVCoupons.h"
#import "TVCoupon.h"
#import "TVExtraBranchView.h"
#import "MHFacebookImageViewer.h"
@interface SpecBranchProfileVC ()
{
@private
    double lastDragOffset;
}
@end

@implementation SpecBranchProfileVC

#pragma mark - UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (UIView *)addGenerationInfoView
{
    UIView *genarateInfoView=[[UIView alloc] initWithFrame:CGRectMake(7, 15, 310, 90)];
    [genarateInfoView setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=genarateInfoView.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    
    
    UILabel *lblBranchName = [[UILabel alloc] initWithFrame:CGRectMake(9, 9, 230, 20)];
    lblBranchName.backgroundColor = [UIColor clearColor];
    lblBranchName.textColor = [UIColor redColor];
    lblBranchName.font = [UIFont fontWithName:@"UVNVanBold" size:(15)];
    lblBranchName.text=_branch.name;
    [genarateInfoView addSubview:lblBranchName];
    
    UIImage *imageDirection=[UIImage imageNamed:@"img_direction_icon"];
    UIImageView* imgDirectionView=[[UIImageView alloc] initWithFrame:CGRectMake(257,9+8 , 9, 9)];
    [imgDirectionView setImage:imageDirection];
    [genarateInfoView addSubview:imgDirectionView];
    
    UILabel *lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(270,9+4, 60, 15)];
    lblDistance.backgroundColor = [UIColor clearColor];
    lblDistance.textColor = [UIColor redColor];
    lblDistance.font = [UIFont fontWithName:@"ArialMT" size:(15)];
    double distance=[[GlobalDataUser sharedAccountClient] distanceFromAddress:_branch.latlng];
    if (distance>1000.0) {
        NSLog(@"%f",distance/1000.0);
        lblDistance.text=[NSString stringWithFormat:@"%.2f km",distance/1000];
    }
    else
        lblDistance.text=[NSString stringWithFormat:@"%f m",distance];
    
    [genarateInfoView addSubview:lblDistance];
    
    UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(8.0+15, 35.0, 210, 12)];
    lblAddress.backgroundColor = [UIColor clearColor];  
    lblAddress.textColor = [UIColor grayColor];
    lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    lblAddress.text=_branch.address_full;
    [genarateInfoView addSubview:lblAddress];
    
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(8.0+15, 53.0, 210, 12)];
    lblPrice.backgroundColor = [UIColor clearColor];
    lblPrice.textColor = [UIColor grayColor];
    lblPrice.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    lblPrice.text=_branch.price_avg;
    [genarateInfoView addSubview:lblPrice];
    
    UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 35.0, 11, 12)];
    homeIcon.image=[UIImage imageNamed:@"img_address_branch_icon"];
    [genarateInfoView addSubview:homeIcon];
    
    UIImageView* price_avgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 53.0, 8, 11)];
    price_avgIcon.image=[UIImage imageNamed:@"img_price_range_branch_icon"];
    [genarateInfoView addSubview:price_avgIcon];
    
    UIImageView*phone_Icon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 71.0, 11, 12)];
    phone_Icon.image=[UIImage imageNamed:@"img_profile_branch_phone"];
    [genarateInfoView addSubview:phone_Icon];
    
    UILabel *lblPhone = [[UILabel alloc] initWithFrame:CGRectMake(10.0+15, 71.0, 210, 12)];
    lblPhone.backgroundColor = [UIColor clearColor];
    lblPhone.textColor = [UIColor grayColor];
    lblPhone.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    lblPhone.text=_branch.phone;
    [genarateInfoView addSubview:lblPhone];
    return genarateInfoView;
}



- (UIView *)addSpecPointViewWithHeight:(int)height
{
    UIView *genarateInfoView=[[UIView alloc] initWithFrame:CGRectMake(7,height, 310, 10)];
    [genarateInfoView setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=genarateInfoView.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];

    UILabel *lblBranchName = [[UILabel alloc] initWithFrame:CGRectMake(9, 9, 230, 30)];
    lblBranchName.backgroundColor = [UIColor clearColor];
    lblBranchName.textColor = [UIColor redColor];
    lblBranchName.font = [UIFont fontWithName:@"UVNVanBold" size:(20)];
    lblBranchName.text=@"ĐIỂM NỔI BẬT";
    [genarateInfoView addSubview:lblBranchName];
    int lineHeight=50;
//    NSLog(@"%@",_branch.special_content);
    for (NSString* str in _branch.special_content) {
        
        UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(8.0+25, lineHeight, 265, 25)];
        lblAddress.backgroundColor = [UIColor clearColor];
        lblAddress.textColor = [UIColor grayColor];
        lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(15)];
        lblAddress.numberOfLines = 0;
        lblAddress.lineBreakMode = UILineBreakModeWordWrap;
        lblAddress.text=str;
        [lblAddress sizeToFit];
        [genarateInfoView addSubview:lblAddress];
        
        UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, lineHeight, 25, 25)];
        homeIcon.image=[UIImage imageNamed:@"img_camera_cell_button"];
        [genarateInfoView addSubview:homeIcon];
        lineHeight+=lblAddress.frame.size.height+5;
    }
    CGRect frame=genarateInfoView.frame;
    frame.size.height+=lineHeight;
    genarateInfoView.frame=frame;
    return genarateInfoView;
}

- (void)showInfoView
{
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    // Generate Infomation Of Branch
    UIView *genarateInfoView = [self addGenerationInfoView];
    [_scrollView addSubview:genarateInfoView];
    
    UIView *specInfoView = [self addSpecPointViewWithHeight:genarateInfoView.frame.origin.y+genarateInfoView.frame.size.height+10];
    [_scrollView addSubview:specInfoView];
    CGRect frame=_scrollView.frame;
    frame.size.height=specInfoView.frame.size.height+specInfoView.frame.origin.y+50;
    frame.size.height=700;
    _scrollView.frame=frame;
}

- (void)viewDidLoad
{
    [self showInfoView];
    TVExtraBranchView *_extraBranchView=[[TVExtraBranchView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 46)];
    _extraBranchView.scrollView=_scrollView;
    _extraBranchView.branchID=@"1";
    [self.view addSubview:_extraBranchView];
    if (_scrollView.frame.size.height<self.view.bounds.size.height) {
//        [_extraBranchView showExtraView:YES];
    }
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(239/255.0f) green:(239/255.0f) blue:(239/255.0f) alpha:1.0f]];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper



#pragma mark - IBAction
-(void)specialContentButtonClicked:(id)sender{
    
}


-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setImgBranchCover:nil];
    [super viewDidUnload];
}

@end
