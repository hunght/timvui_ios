//
//  BranchProfileVC.m
//  TimVui
//
//  Created by Hoang The Hung on 6/5/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "CoupBranchProfileVC.h"
#import "TVAppDelegate.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "GlobalDataUser.h"
#import <QuartzCore/QuartzCore.h>
#import "TVCoupons.h"
#import "TVCoupon.h"
#import "TVExtraBranchView.h"
#import "MHFacebookImageViewer.h"
#import "NSDate+Helper.h"
@interface CoupBranchProfileVC ()
{
@private
    double lastDragOffset;
}
@end

@implementation CoupBranchProfileVC
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
    
    _couponBranch=[[UIView alloc] initWithFrame:CGRectMake(6, genarateInfoView.frame.origin.y+genarateInfoView.frame.size.height+10, 320-6*2, 90)];
    [_couponBranch setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=_couponBranch.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    [_scrollView addSubview:_couponBranch];
    
    
    UIButton* btnPostPhoto = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 300, 46)];
    [btnPostPhoto setBackgroundImage:[UIImage imageNamed:@"img_buttom-big-off"] forState:UIControlStateNormal];
    [btnPostPhoto setBackgroundImage:[UIImage imageNamed:@"img_button_big_on"] forState:UIControlStateHighlighted];
    [btnPostPhoto setTitle:@"NHẬN MÃ CODE" forState:UIControlStateNormal];
    [btnPostPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPostPhoto.titleLabel.font = [UIFont fontWithName:@"UVNVanBold" size:(17)];
    [btnPostPhoto addTarget:self action:@selector(getCouponCode:) forControlEvents:UIControlEventTouchUpInside];
    [_couponBranch addSubview:btnPostPhoto];
    
    //COUPON
    int height_p=btnPostPhoto.frame.origin.y+btnPostPhoto.frame.size.height+15;
        UILabel *lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(5+5 ,height_p , 290, 23)];
        lblDetailRow.backgroundColor = [UIColor clearColor];
        lblDetailRow.textColor = [UIColor blackColor];
        lblDetailRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblDetailRow.text = _coupon.name;
        lblDetailRow.numberOfLines = 0;
        lblDetailRow.lineBreakMode = UILineBreakModeWordWrap;
        [lblDetailRow sizeToFit];

        UIView* borderView=[[UIView alloc] initWithFrame:CGRectMake(5 ,height_p-5 , 297, lblDetailRow.frame.size.height+10)];
        [borderView setBackgroundColor:[UIColor clearColor]];
        
        CAShapeLayer *_border = [CAShapeLayer layer];
        _border.strokeColor = [UIColor colorWithRed:67/255.0f green:37/255.0f blue:83/255.0f alpha:1].CGColor;
        _border.fillColor = nil;
        _border.lineDashPattern = @[@4, @2];
        [borderView.layer addSublayer:_border];
        
        // Setup the path
        _border.path = [UIBezierPath bezierPathWithRect:borderView.bounds].CGPath;
        _border.frame = borderView.bounds;
        
        [[borderView layer] addSublayer:_border];
        [_couponBranch addSubview:borderView];
        [_couponBranch addSubview:lblDetailRow];
        
        //View for info branch
        UIView* infoCouponBranch=[[UIView alloc] initWithFrame:CGRectMake(5, lblDetailRow.frame.origin.y+lblDetailRow.frame.size.height+10, 320-(6+5)*2, 85)];
        [infoCouponBranch setBackgroundColor:[UIColor colorWithRed:(245/255.0f) green:(245/255.0f) blue:(245/255.0f) alpha:1.0f]];
        
        l=infoCouponBranch.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:5.0];
        [l setBorderWidth:1.0];
        [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
        
        UIImageView* quatityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 5, 11, 12)];
        quatityIcon.image=[UIImage imageNamed:@"img_profile_branch_quatity_coupon"];
        [infoCouponBranch addSubview:quatityIcon];
        
        UILabel *lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(50, 5.0, 150, 23)];
        lblTitleRow.backgroundColor = [UIColor clearColor];
        lblTitleRow.textColor = [UIColor grayColor];
        lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblTitleRow.text =@"Số lượng";
        [infoCouponBranch addSubview:lblTitleRow];
        
        UILabel *lblDetailInfoRow = [[UILabel alloc] initWithFrame:CGRectMake(150, 5.0, 150, 23)];
        lblDetailInfoRow.backgroundColor = [UIColor clearColor];
        lblDetailInfoRow.textColor = [UIColor grayColor];
        lblDetailInfoRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblDetailInfoRow.text =_coupon.used;
        [infoCouponBranch addSubview:lblDetailInfoRow];
        
        UIImageView* viewNumberIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 25, 12, 11)];
        viewNumberIcon.image=[UIImage imageNamed:@"img_profile_branch_view_number"];
        [infoCouponBranch addSubview:viewNumberIcon];
        
        lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(50, 25.0, 150, 23)];
        lblTitleRow.backgroundColor = [UIColor clearColor];
        lblTitleRow.textColor = [UIColor grayColor];
        lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblTitleRow.text =@"Lượt xem";
        [infoCouponBranch addSubview:lblTitleRow];
        
        lblDetailInfoRow = [[UILabel alloc] initWithFrame:CGRectMake(150, 25.0, 150, 23)];
        lblDetailInfoRow.backgroundColor = [UIColor clearColor];
        lblDetailInfoRow.textColor = [UIColor grayColor];
        lblDetailInfoRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblDetailInfoRow.text =_coupon.view;
        [infoCouponBranch addSubview:lblDetailInfoRow];
        
        UIImageView* codeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0,45, 12, 13)];
        codeIcon.image=[UIImage imageNamed:@"img_profile_branch_coupon_code"];
        [infoCouponBranch addSubview:codeIcon];
        
        
        lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(50, 45.0, 150, 23)];
        lblTitleRow.backgroundColor = [UIColor clearColor];
        lblTitleRow.textColor = [UIColor grayColor];
        lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblTitleRow.text =@"Mã";
        [infoCouponBranch addSubview:lblTitleRow];
        
        lblDetailInfoRow = [[UILabel alloc] initWithFrame:CGRectMake(150, 45.0, 150, 23)];
        lblDetailInfoRow.backgroundColor = [UIColor clearColor];
        lblDetailInfoRow.textColor = [UIColor grayColor];
        lblDetailInfoRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblDetailInfoRow.text =_coupon.code;
        [infoCouponBranch addSubview:lblDetailInfoRow];
        
        UIImageView* clockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 65, 12, 13)];
        clockIcon.image=[UIImage imageNamed:@"img_profile_branch_coupon_clock"];
        [infoCouponBranch addSubview:clockIcon];
        
        
        lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(50, 65.0, 150, 23)];
        lblTitleRow.backgroundColor = [UIColor clearColor];
        lblTitleRow.textColor = [UIColor grayColor];
        lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblTitleRow.text =@"Thời gian";
        [infoCouponBranch addSubview:lblTitleRow];
        
        lblDetailInfoRow = [[UILabel alloc] initWithFrame:CGRectMake(150, 65.0, 150, 23)];
        lblDetailInfoRow.backgroundColor = [UIColor clearColor];
        lblDetailInfoRow.textColor = [UIColor grayColor];
        lblDetailInfoRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblDetailInfoRow.text =[NSString stringWithFormat:@"%@ - %@",[_coupon.start stringWithFormat:@"dd/MM/yy"], [_coupon.end stringWithFormat:@"dd/MM/yy"]];
        [infoCouponBranch addSubview:lblDetailInfoRow];

    height_p=infoCouponBranch.frame.origin.y+infoCouponBranch.frame.size.height+10;
    [_couponBranch addSubview:infoCouponBranch];
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
//    NSLog(@"%@",_coupon.content);
    //continue building the string
    [html appendString:_coupon.content];
    [html appendString:@"</body></html>"];
    
    //instantiate the web view
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, height_p, 290, 200)];
    
    //make the background transparent
    [webView setBackgroundColor:[UIColor clearColor]];
    
    //pass the string to the webview
    [webView loadHTMLString:[html description] baseURL:nil];
    
    //add it to the subview
    [webView sizeToFit];
    // assuming your self.viewer is a UIWebView
    [webView setDelegate:self];
    [_couponBranch addSubview:webView];
    
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

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect newBounds = webView.frame;
    newBounds.size.height = webView.scrollView.contentSize.height;
    webView.frame = newBounds;
    
    int height_p=webView.frame.origin.y+webView.frame.size.height+10;
    
    UIButton* btnPostPhoto = [[UIButton alloc] initWithFrame:CGRectMake(5, height_p, 300, 46)];
    [btnPostPhoto setBackgroundImage:[UIImage imageNamed:@"img_buttom-big-off"] forState:UIControlStateNormal];
    [btnPostPhoto setBackgroundImage:[UIImage imageNamed:@"img_button_big_on"] forState:UIControlStateHighlighted];
    [btnPostPhoto setTitle:@"NHẬN MÃ CODE" forState:UIControlStateNormal];
    [btnPostPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPostPhoto.titleLabel.font = [UIFont fontWithName:@"UVNVanBold" size:(17)];
    [btnPostPhoto addTarget:self action:@selector(getCouponCode:) forControlEvents:UIControlEventTouchUpInside];
    [_couponBranch addSubview:btnPostPhoto];
    
    height_p=btnPostPhoto.frame.origin.y+btnPostPhoto.frame.size.height+10;
    
    [_scrollView addSubview:_couponBranch];
    CGRect frame=_couponBranch.frame;
    frame.size.height=height_p;
    _couponBranch.frame=frame;
    
    height_p=_couponBranch.frame.origin.y+_couponBranch.frame.size.height+30;
    
    [_scrollView setContentSize:CGSizeMake(320, height_p)];
    
}


#pragma mark - IBAction
-(void)getCouponCode:(id)s{
    
}

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
