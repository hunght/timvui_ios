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
#import "NSDate-Utilities.h"
#import "TVBranches.h"
#import "TSMessage.h"
#import "TVSMSVC.h"
#import "SIAlertView.h"
#import "CMHTMLView.h"
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
- (void)setConnerBorderWithLayer:(CALayer *)l
{
    [l setMasksToBounds:YES];
    [l setCornerRadius:1.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
}
- (UIView *)addGenerationInfoView
{
    UIView *genarateInfoView=[[UIView alloc] initWithFrame:CGRectMake(7, 7, 310, 90)];
    [genarateInfoView setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=genarateInfoView.layer;
    [self setConnerBorderWithLayer:l];
    
    UILabel *lblBranchName = [[UILabel alloc] initWithFrame:CGRectMake(9, 9, 230, 20)];
    lblBranchName.backgroundColor = [UIColor clearColor];
    lblBranchName.textColor = [UIColor blackColor];
    lblBranchName.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
    lblBranchName.text=_branch.name;
    [genarateInfoView addSubview:lblBranchName];
    
    
    UILabel *lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(270,9+4, 60, 15)];
    lblDistance.backgroundColor = [UIColor clearColor];
    lblDistance.textColor = [UIColor grayColor];
    lblDistance.font = [UIFont fontWithName:@"ArialMT" size:(10)];
    double distance=[[GlobalDataUser sharedAccountClient] distanceFromAddress:_branch.latlng];
    if (distance<0) {
        lblDistance.hidden=YES;
    }else{
        lblDistance.hidden=NO;
        if (distance>1000.0)
            lblDistance.text=[NSString stringWithFormat:@"%.01f km",distance/1000];
        else
            lblDistance.text=[NSString stringWithFormat:@"%.01f m",distance];
    }
    
    [genarateInfoView addSubview:lblDistance];
    
    UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(8.0+15, 35.0, 260, 12)];
    lblAddress.backgroundColor = [UIColor clearColor];
    lblAddress.textColor = [UIColor grayColor];
    lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(11)];
    lblAddress.text=_branch.address_full;
    [genarateInfoView addSubview:lblAddress];
    
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(8.0+15, 53.0, 210, 12)];
    lblPrice.backgroundColor = [UIColor clearColor];
    lblPrice.textColor = [UIColor grayColor];
    lblPrice.font = [UIFont fontWithName:@"ArialMT" size:(11)];
    lblPrice.text=(_branch.price_avg && ![_branch.price_avg isEqualToString:@""])?_branch.price_avg:@"Đang cập nhật";
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
    lblPhone.font = [UIFont fontWithName:@"ArialMT" size:(11)];
    lblPhone.text=(_branch.phone && ![_branch.phone isEqualToString:@""])?_branch.phone:@"Đang cập nhật";
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
    lblBranchName.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(20)];
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
- (void)settingTextForTitle:(UILabel *)lblTitle
{
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
}

- (void)showInfoView
{
    
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
    btnPostPhoto.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(17)];
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
    _border.strokeColor =[UIColor colorWithRed:(220/255.0f) green:(220/255.0f) blue:(220/255.0f) alpha:1.0f].CGColor;
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
        UIView* infoCouponBranch=[[UIView alloc] initWithFrame:CGRectMake(5, lblDetailRow.frame.origin.y+lblDetailRow.frame.size.height+10, 320-(6+5)*2, 85+ 20)];
        [infoCouponBranch setBackgroundColor:[UIColor colorWithRed:(245/255.0f) green:(245/255.0f) blue:(245/255.0f) alpha:1.0f]];
        
        l=infoCouponBranch.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:5.0];
        [l setBorderWidth:1.0];
        [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
        
        UIImageView* quatityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 5+ 3, 11, 12)];
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
        lblDetailInfoRow.text =_coupon.use_number;
        [infoCouponBranch addSubview:lblDetailInfoRow];
        
        UIImageView* viewNumberIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 25+ 3, 12, 11)];
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
        
    UIImageView* viewedNumberIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0,45+ 3, 12, 13)];
    viewedNumberIcon.image=[UIImage imageNamed:@"img_profile_branch_coupon_code"];
    [infoCouponBranch addSubview:viewedNumberIcon];
    
    lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(50, 45.0, 150, 23)];
    lblTitleRow.backgroundColor = [UIColor clearColor];
    lblTitleRow.textColor = [UIColor grayColor];
    lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    lblTitleRow.text =@"Lượt mua";
    [infoCouponBranch addSubview:lblTitleRow];
    
    lblDetailInfoRow = [[UILabel alloc] initWithFrame:CGRectMake(150, 45.0, 150, 23)];
    lblDetailInfoRow.backgroundColor = [UIColor clearColor];
    lblDetailInfoRow.textColor = [UIColor grayColor];
    lblDetailInfoRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    lblDetailInfoRow.text =_coupon.used_number;
    [infoCouponBranch addSubview:lblDetailInfoRow];
    
    UIImageView* codeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0,45+ 20+ 3, 12, 13)];
    codeIcon.image=[UIImage imageNamed:@"img_profile_branch_coupon_code"];
    [infoCouponBranch addSubview:codeIcon];
    
    lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(50, 45.0+ 20, 150, 23)];
    lblTitleRow.backgroundColor = [UIColor clearColor];
    lblTitleRow.textColor = [UIColor grayColor];
    lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    lblTitleRow.text =@"Mã";
    [infoCouponBranch addSubview:lblTitleRow];
    
    lblDetailInfoRow = [[UILabel alloc] initWithFrame:CGRectMake(150, 45.0+ 20, 150, 23)];
    lblDetailInfoRow.backgroundColor = [UIColor clearColor];
    lblDetailInfoRow.textColor = [UIColor grayColor];
    lblDetailInfoRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    lblDetailInfoRow.text =_coupon.syntax;
    [infoCouponBranch addSubview:lblDetailInfoRow];
    
    UIImageView* clockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 65+ 20+ 3, 12, 13)];
    clockIcon.image=[UIImage imageNamed:@"img_profile_branch_coupon_clock"];
    [infoCouponBranch addSubview:clockIcon];
    
    lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(50, 65.0+ 20, 150, 23)];
    lblTitleRow.backgroundColor = [UIColor clearColor];
    lblTitleRow.textColor = [UIColor grayColor];
    lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    lblTitleRow.text =@"Hạn sử dụng";
    [infoCouponBranch addSubview:lblTitleRow];
    
    lblDetailInfoRow = [[UILabel alloc] initWithFrame:CGRectMake(150, 65.0+ 20, 150, 23)];
    lblDetailInfoRow.backgroundColor = [UIColor clearColor];
    lblDetailInfoRow.textColor = [UIColor grayColor];
    lblDetailInfoRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    lblDetailInfoRow.text =[NSString stringWithFormat:@"%@ - %@",[_coupon.start stringWithFormat:@"dd/MM/yy"], [_coupon.end stringWithFormat:@"dd/MM/yy"]];
    [infoCouponBranch addSubview:lblDetailInfoRow];

    height_p=infoCouponBranch.frame.origin.y+infoCouponBranch.frame.size.height+10;
    [_couponBranch addSubview:infoCouponBranch];
    
    if (_coupon.special_content&& ![_coupon.special_content isEqualToString:@""]) {
        UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, height_p, 210, 23)];
        [self settingTextForTitle:lblTitle];
        lblTitle.text=@"ĐIỂM NỔI BẬT";
        [_couponBranch addSubview:lblTitle];
        height_p=lblTitle.frame.origin.y+lblTitle.frame.size.height+ 10;
    }
    
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><meta name=\"viewport\" content=\"user-scalable=no, width=200, initial-scale=.7, maximum-scale=.7\"/> <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" /><title></title></head><body style=\"background:transparent;\">"];
    [html appendString:_coupon.special_content];
//    NSLog(@"special_content= %@",_coupon.special_content);
    [html appendString:@"</body></html>"];
    
    __block int heidhtBlock=height_p;
    
    CMHTMLView* htmlView = [[CMHTMLView alloc] initWithFrame:CGRectMake(10, height_p, 290, 25)] ;
    htmlView.backgroundColor = [UIColor whiteColor];
//    htmlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [_couponBranch addSubview:htmlView];
    htmlView.alpha = 0;
    [htmlView.scrollView setScrollEnabled:NO];
    [htmlView loadHtmlBody:html competition:^(NSError *error) {
        if (!error) {
            [self webViewDidFinishLoad:htmlView];
            
            heidhtBlock=htmlView.frame.origin.y+htmlView.frame.size.height+10;
            
            [UIView animateWithDuration:0.2 animations:^{
                htmlView.alpha = 1;
            }];
            if (_coupon.condition_content&& ![_coupon.condition_content isEqualToString:@""]) {
                UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, heidhtBlock, 210, 23)];
                [self settingTextForTitle:lblTitle];
                lblTitle.text=@"ĐIỀU KIỆN SỬ DỤNG";
                [_couponBranch addSubview:lblTitle];
                heidhtBlock=lblTitle.frame.origin.y+lblTitle.frame.size.height+10;
            }

            //create the string
            NSMutableString *html = [NSMutableString stringWithString: @"<html><head><meta name=\"viewport\" content=\"user-scalable=no, width=200, initial-scale=.7, maximum-scale=.7\"/> <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" /><title></title></head><body style=\"background:transparent;\">"];
            
//                NSLog(@"condition_content= %@",_coupon.condition_content);
            //continue building the string
            [html appendString:_coupon.condition_content];
            [html appendString:@"</body></html>"];
            
            CMHTMLView* htmlView = [[CMHTMLView alloc] initWithFrame:CGRectMake(10, heidhtBlock, 290, 25)] ;
            htmlView.backgroundColor = [UIColor whiteColor];
            [_couponBranch addSubview:htmlView];
//            htmlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            htmlView.alpha = 0;
            [htmlView.scrollView setScrollEnabled:NO];
            [htmlView loadHtmlBody:html competition:^(NSError *error) {
                if (!error) {
                    [self webViewDidFinishLoad:htmlView];
                    heidhtBlock=htmlView.frame.origin.y+htmlView.frame.size.height+10;
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        htmlView.alpha = 1;
                    }];
                    
                    if (_coupon.content&& ![_coupon.content isEqualToString:@""]) {
                        UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, heidhtBlock, 210, 23)];
                        [self settingTextForTitle:lblTitle];
                        lblTitle.text=@"NỘI DUNG CHI TIẾT";
                        [_couponBranch addSubview:lblTitle];
                        heidhtBlock=lblTitle.frame.origin.y+lblTitle.frame.size.height+10;
                    }
                    //create the string
                    NSMutableString *html = [NSMutableString stringWithString: @"<html><head></head><body style=\"background:transparent;\">"];
                    
//                        NSLog(@"content= %@",_coupon.content);
                    //continue building the string
                    [html appendString:_coupon.content];
                    [html appendString:@"</body></html>"];
                    
                    CMHTMLView* htmlView = [[CMHTMLView alloc] initWithFrame:CGRectMake(10, heidhtBlock, 290, 25)] ;
                    [_couponBranch addSubview:htmlView];
                    htmlView.backgroundColor = [UIColor whiteColor];
//                    htmlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    
                    htmlView.alpha = 0;
                    [htmlView.scrollView setScrollEnabled:NO];
                    [htmlView loadHtmlBody:html competition:^(NSError *error) {
                        if (!error) {
                            [UIView animateWithDuration:0.2 animations:^{
                                htmlView.alpha = 1;
                            }];
                            [self webViewDidFinishLoad:htmlView];
                            
                            int height_p=htmlView.frame.origin.y+htmlView.frame.size.height+10;
                            
                            UIButton* btnPostPhoto = [[UIButton alloc] initWithFrame:CGRectMake(5, height_p, 300, 46)];
                            [btnPostPhoto setBackgroundImage:[UIImage imageNamed:@"img_buttom-big-off"] forState:UIControlStateNormal];
                            [btnPostPhoto setBackgroundImage:[UIImage imageNamed:@"img_button_big_on"] forState:UIControlStateHighlighted];
                            [btnPostPhoto setTitle:@"NHẬN MÃ CODE" forState:UIControlStateNormal];
                            [btnPostPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            btnPostPhoto.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(17)];
                            [btnPostPhoto addTarget:self action:@selector(getCouponCode:) forControlEvents:UIControlEventTouchUpInside];
                            [_couponBranch addSubview:btnPostPhoto];
                            
                            height_p=btnPostPhoto.frame.origin.y+btnPostPhoto.frame.size.height+10;
                            
                            CGRect frame=_couponBranch.frame;
                            frame.size.height=height_p;
                            _couponBranch.frame=frame;
                            
                            height_p=_couponBranch.frame.origin.y+_couponBranch.frame.size.height+30;
                            
                            [_scrollView setContentSize:CGSizeMake(320, height_p)];
                        }
                    }];
                    
                    
                }
            }];
            
            
            
        }
    }];
    
    
}

- (void)displayInfoWhenGetBranch
{
    [self showInfoView];
    TVExtraBranchView *_extraBranchView=[[TVExtraBranchView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 41) andBranch:_branch withViewController:self];
    _extraBranchView.scrollView=_scrollView;
    [self.view addSubview:_extraBranchView];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(239/255.0f) green:(239/255.0f) blue:(239/255.0f) alpha:1.0f]];
}

- (void)viewDidLoad
{

    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    
    if (!_branch) {
        TVBranches* branches=[[TVBranches alloc] initWithPath:@"branch/getById"];
        branches.isNotSearchAPIYES=YES;
        NSDictionary *params = @{@"id": _branchID};
//        NSDictionary *params = @{@"id": @"1"};
        [branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
            dispatch_async( dispatch_get_main_queue(),^ {
                _branch=branches[0];
                [self displayInfoWhenGetBranch];
            });
        } failure:^(GHResource *instance, NSError *error) {
            dispatch_async( dispatch_get_main_queue(),^ {
                
            });
        }];
    }else
        [self displayInfoWhenGetBranch];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper

-(void)webViewDidFinishLoad:(CMHTMLView *)webView {
    CGRect newBounds = webView.frame;
    newBounds.size.height = webView.scrollView.contentSize.height;
    webView.frame = newBounds;
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    NSLog(@"web height=%@",result);
    
}

#pragma mark MFMessageComposeViewControllerDelegate
// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
	// Notifies users about errors associated with the interface
    NSString* strAlarm;
	switch (result)
	{
		case MessageComposeResultCancelled:
            strAlarm=@"Bạn đã từ chối gửi tin nhắn nhận coupon";
			break;
		case MessageComposeResultSent:{
            strAlarm= @"Bạn đã gửi tín nhắn thành công. Vui lòng đợi tin nhắn trả về của chúng tôi.";
			break;
        }
		case MessageComposeResultFailed:
            strAlarm=@"Có lỗi trong việc gửi tin nhắn. Vui lòng kiểm tra tài khoản của bạn";
			break;
		default:
			strAlarm=@"Có lỗi trong việc gửi tin nhắn. Vui lòng kiểm tra tài khoản của bạn" ;
			break;
	}
    
    [TSMessage showNotificationInViewController:self
                                      withTitle:strAlarm
                                    withMessage:nil
                                       withType:TSMessageNotificationTypeWarning];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - IBAction


#pragma mark - IBAction

-(void)getCouponCode:(id)s{
    NSLog(@"[[GlobalDataUser sharedAccountClient].receivedCouponIDs = %@",[GlobalDataUser sharedAccountClient].receivedCouponIDs);
    if ([[GlobalDataUser sharedAccountClient].receivedCouponIDs valueForKey:_coupon.couponID]) {
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Bạn đã có coupon này và sẵn sàng để sử dụng."
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeSuccess];
    }else{
        [TVSMSVC viewOptionSMSWithViewController:self andCoupon:_coupon];
    }
}



- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setImgBranchCover:nil];
    [super viewDidUnload];
}

@end
