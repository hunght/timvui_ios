//
//  BranchProfileVC.m
//  TimVui
//
//  Created by Hoang The Hung on 6/5/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "BranchProfileVC.h"
#import "TVAppDelegate.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "GlobalDataUser.h"
#import <QuartzCore/QuartzCore.h>
#import "TVCoupons.h"
#import "TVCoupon.h"
#import "TVExtraBranchView.h"
#import "MHFacebookImageViewer.h"
#import "TSMessage.h"
#import "TVPhotoBrowserVC.h"
#import "NSDate-Utilities.h"
#import "CoupBranchProfileVC.h"
#import "TVNetworkingClient.h"
#import <SVProgressHUD.h>
#import "SearchWithContactsVC.h"
#import "TVBranches.h"
#import "NSDictionary+Extensions.h"
#import "UILabel+DynamicHeight.h"
#import "SIAlertView.h"
#import "FacebookServices.h"

@interface BranchProfileVC ()
{
@private
    int heightDefaultScroll;
    int sizeHeightDefaultScroll;
    double lastDragOffset;
    UIView *_introducingView;
}
@end

@implementation BranchProfileVC

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
    UIView *genarateInfoView=[[UIView alloc] initWithFrame:CGRectMake(7, 186, 310, 90)];
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
    if (distance>1000.0)
        lblDistance.text=[NSString stringWithFormat:@"%.01f km",distance/1000];
    else
        lblDistance.text=[NSString stringWithFormat:@"%.01f m",distance];
    
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
    lblPhone.font = [UIFont fontWithName:@"ArialMT" size:(11)];
    lblPhone.text=_branch.phone;
    [genarateInfoView addSubview:lblPhone];
    return genarateInfoView;
    
    
}

- (void)setConnerBorderWithLayer:(CALayer *)l
{
    [l setMasksToBounds:YES];
    [l setCornerRadius:1.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
}

- (void)settingTextForTitle:(UILabel *)lblTitle
{
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
}

- (void)addCouponToInfoView:(int *)height_p
{
    CALayer *l;
    if (_branch.coupons.items.count>0) {
        UIView* couponBranch=[[UIView alloc] initWithFrame:CGRectMake(6, *height_p, 320-6*2, 90)];
        [couponBranch setBackgroundColor:[UIColor whiteColor]];
        l=couponBranch.layer;
        [self setConnerBorderWithLayer:l];
        [_scrollView addSubview:couponBranch];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 19, 210, 23)];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
        lblTitle.text=@"COUPON";
        [couponBranch addSubview:lblTitle];
        UIImageView* imageLine=[[UIImageView alloc] initWithFrame:CGRectMake(5, 19+23, 295, 3)];
        [imageLine setImage:[UIImage imageNamed:@"img_profile_branch_line"]];
        [couponBranch addSubview:imageLine];
        //COUPON
        *height_p=imageLine.frame.origin.y+imageLine.frame.size.height+15;
        
        
        
        int i=0;
        for (TVCoupon* coupon in _branch.coupons.items) {
            
            
            UILabel *lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(5+5 ,*height_p , 290, 23)];
            lblDetailRow.backgroundColor = [UIColor clearColor];
            lblDetailRow.textColor = [UIColor redColor];
            lblDetailRow.font = [UIFont fontWithName:@"Arial-BoldMT" size:(12)];
            lblDetailRow.text = coupon.name;
            [lblDetailRow resizeToStretch];
            
            UIView* borderView=[[UIView alloc] initWithFrame:CGRectMake(5 ,*height_p-5 , 297, lblDetailRow.frame.size.height+10)];
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
            [couponBranch addSubview:borderView];
            [couponBranch addSubview:lblDetailRow];
            
            *height_p=lblDetailRow.frame.origin.y+lblDetailRow.frame.size.height+20;
            
            UIButton* btnSMS = [[UIButton alloc] initWithFrame:CGRectMake(5, *height_p, 75, 25)];
            [btnSMS setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_compose"] forState:UIControlStateNormal];
            
            [btnSMS addTarget:self action:@selector(btnSMSButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btnSMS setTag:i];
            [couponBranch addSubview:btnSMS];
            *height_p=btnSMS.frame.origin.y+btnSMS.frame.size.height;
            
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, *height_p, 170, 23)];
            [self settingTextForTitle:lblTitle];
            lblTitle.text=[NSString stringWithFormat:@"COUPON %@",coupon.syntax];
            [couponBranch addSubview:lblTitle];
            
            UILabel *lblSendTo = [[UILabel alloc] initWithFrame:CGRectMake(170+10.0, *height_p, 130, 23)];
            lblSendTo.backgroundColor = [UIColor clearColor];
            lblSendTo.textColor = [UIColor blackColor];
            lblSendTo.font = [UIFont fontWithName:@"Arial-BoldMT" size:(20)];
            lblSendTo.text=[NSString stringWithFormat:@"gửi tới %@",SMS_NUMBER];
            [couponBranch addSubview:lblSendTo];
            *height_p=lblSendTo.frame.origin.y+lblSendTo.frame.size.height+10;
            
            //View for info coupon
            UIView* infoCouponBranch=[[UIView alloc] initWithFrame:CGRectMake(5, *height_p, 320-(6+5)*2, 85)];
            [infoCouponBranch setBackgroundColor:[UIColor colorWithRed:(245/255.0f) green:(245/255.0f) blue:(245/255.0f) alpha:1.0f]];
            
            l=infoCouponBranch.layer;
            //            [self setConnerBorderWithLayer:l];
            [l setMasksToBounds:YES];
            [l setCornerRadius:1.0];
            
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
            lblDetailInfoRow.text =coupon.used;
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
            lblDetailInfoRow.text =coupon.view;
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
            lblDetailInfoRow.text =coupon.syntax;
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
            lblDetailInfoRow.text =[NSString stringWithFormat:@"%@ - %@",[coupon.start stringWithFormat:@"dd/MM/yy"], [coupon.end stringWithFormat:@"dd/MM/yy"]];
            [infoCouponBranch addSubview:lblDetailInfoRow];
            
            
            *height_p=infoCouponBranch.frame.origin.y+infoCouponBranch.frame.size.height+10;
            
            
            UIButton* btnPostPhoto = [[UIButton alloc] initWithFrame:CGRectMake(5, *height_p, 300, 46)];
            [btnPostPhoto setBackgroundImage:[Utilities imageFromColor:kDeepOrangeColor] forState:UIControlStateNormal];
            [btnPostPhoto setBackgroundImage:[Utilities imageFromColor:kOrangeColor] forState:UIControlStateHighlighted];
            [btnPostPhoto setTitle:@"XEM CHI TIẾT" forState:UIControlStateNormal];
            [btnPostPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnPostPhoto.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(17)];
            
            [btnPostPhoto addTarget:self action:@selector(viewDetailCouponClicked:) forControlEvents:UIControlEventTouchUpInside];
            btnPostPhoto.tag=i;
            i++;
            [couponBranch addSubview:btnPostPhoto];
            
            *height_p=btnPostPhoto.frame.origin.y+btnPostPhoto.frame.size.height+50;
            [couponBranch addSubview:infoCouponBranch];
        }
        
        [_scrollView addSubview:couponBranch];
        CGRect frame=couponBranch.frame;
        frame.size.height=*height_p;
        couponBranch.frame=frame;
        
        *height_p= couponBranch.frame.origin.y+couponBranch.frame.size.height+10;
    }
}

- (void)showInfoView
{
    // Do any additional setup after loading the view from its nib.
    [_imgBranchCover setImageWithURL:[Utilities getLargeImageOfCoverBranch:_branch.arrURLImages] placeholderImage:nil];
    
    //    NSLog(@"[Ultilities getLargeImageOfCoverBranch:_branch.arrURLImages]%@",[Ultilities getLargeImageOfCoverBranch:_branch.arrURLImages]);
    //    NSArray* imageDicArr=[_branch.images ];
    //Show Ablum images
    int i=0;
    for (NSArray* imagesArr in [_branch.images allValues]) {
        
        for (NSDictionary* images in imagesArr) {
            NSLog(@"images%@",images);
            UIImageView* imageButton = [[UIImageView alloc] initWithFrame:CGRectMake(6+52*i, 140, 50, 35)];
            [imageButton setImageWithURL:[Utilities getThumbImageOfCoverBranch:[images safeDictForKey:@"image"]]];
            imageButton.tag=i;
            [_scrollView addSubview:imageButton];
            [imageButton setupImageViewerWithImageURL:[Utilities getLargeImageOfCoverBranch:images] onOpen:^{
                NSLog(@"OPEN!");
            } onClose:^{
                NSLog(@"CLOSE!");
            }];
            i++;
            if (i==3)break;
        }
        if (i==3)break;
    }
    
    if (i>=3) {
        UIButton* imageButton = [[UIButton alloc] initWithFrame:CGRectMake(6+52*i, 140, 50, 35)];
        //        [NSString stringWithFormat:@"+%d",_branch.image_count-3]
        [imageButton setTitle:@"+" forState:UIControlStateNormal];
        [imageButton setTitle:@"+" forState:UIControlStateSelected];
        [imageButton setBackgroundColor:[UIColor whiteColor]];
        imageButton.titleLabel.textColor=[UIColor redColor];
        [imageButton addTarget:self action:@selector(albumButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:imageButton];
    }
    
    //Show mapView button
    NSString* latlng=[NSString stringWithFormat:@"%f,%f",_branch.latlng.latitude,_branch.latlng.longitude];
    NSString* strURL=[NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@&zoom=15&size=160x160&markers=size:mid%@color:red%@%@&sensor=false",latlng,@"%7C",@"%7C",latlng];
    //    NSLog(@"strURL = %@",strURL);
    NSURL* url=[NSURL URLWithString:strURL];
    UIButton* mapViewButton = [[UIButton alloc] initWithFrame:CGRectMake(218, 106, 97, 72)];
    [mapViewButton setImageWithURL:url];
    [mapViewButton addTarget:self action:@selector(mapViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    CALayer* l=mapViewButton.layer;
    [self setConnerBorderWithLayer:l];
    [_scrollView addSubview:mapViewButton];
    
    UIView* bgImageView=[[UIView alloc] initWithFrame:CGRectMake(0, 140-5, 320, 35+10)];
    [bgImageView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
    //    [_scrollView insertSubview:bgImageView belowSubview:mapViewButton];
    [_scrollView insertSubview:bgImageView atIndex:0];
    
    // Generate Infomation Of Branch
    UIView *genarateInfoView = [self addGenerationInfoView];
    [_scrollView addSubview:genarateInfoView];
    
    //Button Camera, Comment, Follow
    UIButton* cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(7, genarateInfoView.frame.origin.y+genarateInfoView.frame.size.height+ 15, 100, 44)];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_camera"] forState:UIControlStateNormal];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_camera_on"] forState:UIControlStateHighlighted];
    [cameraButton setTitle:@"             CHỤP ẢNH" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cameraButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    [cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:cameraButton];
    
    UIButton* commentButton = [[UIButton alloc] initWithFrame:CGRectMake(7+101+5, genarateInfoView.frame.origin.y+genarateInfoView.frame.size.height+ 15, 100, 44)];
    [commentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment"] forState:UIControlStateNormal];
    [commentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment_on"] forState:UIControlStateHighlighted];
    [commentButton setTitle:@"          ĐÁNH GIÁ" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    
    [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:commentButton];
    
    UIButton* likeButton = [[UIButton alloc] initWithFrame:CGRectMake(7+101*2+5*2, genarateInfoView.frame.origin.y+genarateInfoView.frame.size.height+ 15, 100, 44)];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_like"] forState:UIControlStateNormal];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_like_on"] forState:UIControlStateHighlighted];
    [likeButton setTitle:@"          QUAN TÂM" forState:UIControlStateNormal];
    [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    likeButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    
    [likeButton addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:likeButton];
    
    int height= likeButton.frame.origin.y+likeButton.frame.size.height+10;
    
    [self addCouponToInfoView:&height];
    
    //Detail Info
    UIView* detailInfoBranch=[[UIView alloc] initWithFrame:CGRectMake(6, height, 320-6*2, 45)];
    [detailInfoBranch setBackgroundColor:[UIColor whiteColor]];
    l=detailInfoBranch.layer;
    [self setConnerBorderWithLayer:l];
    [_scrollView addSubview:detailInfoBranch];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 19, 210, 23)];
    [self settingTextForTitle:lblTitle];
    lblTitle.text=@"Thông tin";
    [detailInfoBranch addSubview:lblTitle];
    UIImageView* imageLine=[[UIImageView alloc] initWithFrame:CGRectMake(5, 19+23, 295, 3)];
    [imageLine setImage:[UIImage imageNamed:@"img_profile_branch_line"]];
    [detailInfoBranch addSubview:imageLine];
    
    int heightDetailInfo=imageLine.frame.origin.y+imageLine.frame.size.height +12;
    //Style foody
    
    NSString* strDetail=[_branch.cats valueForKey:@"name"];
    NSString* strTiltle=@"Thể loại";
    
    
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=[_branch.district valueForKey:@"name"];
    strTiltle=@"Khu vực";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=[_branch.public_locations valueForKey:@"name"];
    strTiltle=@"Ở gần";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=_branch.direction;
    strTiltle=@"Chỉ đường";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=_branch.space;
    strTiltle=@"Sức chứa";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=[self getDetailStringFrom:_branch.decoration];
    strTiltle=@"Không gian";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=[NSString stringWithFormat:@"%@- %@",_branch.time_open,_branch.time_open];
    strTiltle=@"Thời gian hoạt động";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    
    strDetail=[NSString stringWithFormat:@"Khoảng %@- %@ phút",_branch.waiting_start,_branch.waiting_end];;
    strTiltle=@"Thời gian chuẩn bị";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=_branch.holiday;
    strTiltle=@"Nghỉ lễ";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=_branch.year;
    strTiltle=@"Năm thành lập";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    
    strTiltle=@"Thích hợp";
    strDetail=[self getDetailStringFrom:_branch.adaptive];
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=nil;
    strTiltle=@"Phong cách ẩm thực";
    if ([[_branch.styleFoody allValues] count]>0) {
        NSString* strStyleFoody=@"";
        BOOL isFistTime=YES;
        
        for (NSDictionary* dicStyle in [_branch.styleFoody allValues]) {
            NSLog(@"dicStyle = %@",dicStyle);
            NSString* strStyleFoodyRow=@"";
            if ([[dicStyle valueForKey:@"params"] count]>0) {
                for (NSDictionary* dicStyleDeeper in [dicStyle valueForKey:@"params"] ){
                    NSLog(@"dicStyleDeeper = %@",dicStyleDeeper);
                    strStyleFoodyRow=[strStyleFoodyRow stringByAppendingFormat:@"%@-%@",[dicStyle valueForKey:@"name"],[dicStyleDeeper valueForKey:@"name"]];
                }
            }else
                strStyleFoodyRow=[dicStyle valueForKey:@"name"];
            
            if (isFistTime) {
                isFistTime=NO;
                strStyleFoody=[strStyleFoody stringByAppendingFormat:@"%@",strStyleFoodyRow];
            }else
                strStyleFoody=[strStyleFoody stringByAppendingFormat:@", %@",strStyleFoodyRow];
        }
        strDetail=strStyleFoody;
    }
    
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strTiltle=@"Phù hợp mục đích";
    strDetail=[self getDetailStringFrom:_branch.purpose];
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strTiltle=@"Phù hợp các món";
    strDetail=[self getDetailStringFrom:_branch.cuisine];
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    CGRect frame=detailInfoBranch.frame;
    frame.size.height=heightDetailInfo + 0;
    [detailInfoBranch setFrame:frame];
    
    // Utilities
    UIView* utilitiesView=[[UIView alloc] initWithFrame:CGRectMake(6, detailInfoBranch.frame.origin.y+detailInfoBranch.frame.size.height+10, 320-6*2, 45)];
    [utilitiesView setBackgroundColor:[UIColor whiteColor]];
    l=utilitiesView.layer;
    [self setConnerBorderWithLayer:l];
    [_scrollView addSubview:utilitiesView];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 19, 210, 23)];
    [self settingTextForTitle:lblTitle];
    lblTitle.text=@"Tiện ích";
    [utilitiesView addSubview:lblTitle];
    imageLine=[[UIImageView alloc] initWithFrame:CGRectMake(5, 19+23, 295, 3)];
    [imageLine setImage:[UIImage imageNamed:@"img_profile_branch_line"]];
    [utilitiesView addSubview:imageLine];
    int heightUtilities=imageLine.frame.origin.y+imageLine.frame.size.height +27;
    int rowCount=0;
    
    NSDictionary* params=[SharedAppDelegate getParamData];
    NSDictionary* dicUtilities=[[[params valueForKey:@"data"] valueForKey:@"tien-ich"] valueForKey:@"params"];
    //    NSDictionary*dicUtilities=_branch.services;
    int heightPreRow=0;
    for (NSDictionary* dic in [dicUtilities allValues]) {
        UIImageView *iconIView = [[UIImageView alloc] initWithFrame:CGRectMake((rowCount%2) ?165:8,heightUtilities, 18, 18)];
        
        BOOL isServiceOnYES=NO;
        for (NSDictionary *dicOn in [_branch.services allValues]) {
            NSString* strOne=[dicOn valueForKey:@"alias"];
            NSString* strTwo=[dic valueForKey:@"alias"];
            if ([strOne isEqualToString:strTwo]){
                isServiceOnYES=YES;
                break;
            }
        }
        [utilitiesView addSubview:iconIView];
        
        UILabel *lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(iconIView.frame.origin.x+iconIView.frame.size.width+3, heightUtilities+3, 130, 23)];
        
        lblDetailRow.backgroundColor = [UIColor clearColor];
        lblDetailRow.textColor = [UIColor blackColor];
        lblDetailRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblDetailRow.text =[dic valueForKey:@"name"];
        [lblDetailRow resizeToStretch];
        [utilitiesView addSubview:lblDetailRow];
        
        NSString * strImageName;
        if (isServiceOnYES){
            strImageName=[NSString stringWithFormat:@"%@_on",[dic valueForKey:@"id"]];
            lblDetailRow.textColor = [UIColor colorWithRed:(0/255.0f) green:(180/255.0f) blue:(220/255.0f) alpha:1.0f];
        }else{
            lblDetailRow.textColor = [UIColor grayColor];
            strImageName=[dic valueForKey:@"id"];
        }
        
        [iconIView setImage:[UIImage imageNamed:strImageName]];
        
        rowCount++;
        if (rowCount>1&& !(rowCount%2)) {
            int padRow=(lblDetailRow.frame.size.height>heightPreRow)?lblDetailRow.frame.size.height:heightPreRow;
            heightUtilities+=padRow+ 10;
            heightPreRow=0;
        }else
            heightPreRow=lblDetailRow.frame.size.height;
    }
    
    frame=utilitiesView.frame;
    
    if (rowCount%2)
        frame.size.height=heightUtilities +26+ 10;
    else
        frame.size.height=heightUtilities + 10;
    
    [utilitiesView setFrame:frame];
    height =utilitiesView.frame.origin.y +utilitiesView.frame.size.height+40;
    
    [self addSpecPointViewWithHeight:height];
}
-(void)openTabNow{
    switch (_openTab) {
        case kOpenEventTab:
        {
            [_extraBranchView showExtraView:YES];
            [_extraBranchView eventButtonClicked:nil];
        }
            break;
        case kOpenCouponTab:
        {
            [_extraBranchView showExtraView:NO];
            [_extraBranchView eventButtonClicked:nil];
        }
            break;
        default:
            break;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setbackground color dot line
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
    
    UIButton* shareButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [shareButton setImage:[UIImage imageNamed:@"img_profile_branch_share_button"] forState:UIControlStateNormal];
    //    [shareButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = shareButtonItem;
    
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    TVBranches* branches=[[TVBranches alloc] initWithPath:@"branch/getById"];
    branches.isNotSearchAPIYES=YES;
    
    
    if (!_branch) {
        //NSDictionary *params = @{@"id": _branchID};
        NSDictionary *params = @{@"id": @"1"};
        [branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
            dispatch_async( dispatch_get_main_queue(),^ {
                NSLog(@"data===%@",data);
                NSDictionary* dict=[[data safeArrayForKey:@"data"] objectAtIndex:0];
                _branch=branches[0];
                [self showInfoView];
                
                if (!_extraBranchView) {
                    _extraBranchView=[[TVExtraBranchView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 41) andBranch:_branch withViewController:self];
                    _extraBranchView.scrollView=_scrollView;
                    [self.view addSubview:_extraBranchView];
                }
                
                if(![[GlobalDataUser sharedAccountClient].recentlyBranches objectForKey:_branch.branchID])[[GlobalDataUser sharedAccountClient].recentlyBranches setObject:dict forKey:_branch.branchID];
                
                [self openTabNow];
                
                
            });
        } failure:^(GHResource *instance, NSError *error) {
            dispatch_async( dispatch_get_main_queue(),^ {
                
            });
        }];
    }else{
        [self showInfoView];
        if (!_extraBranchView) {
            _extraBranchView=[[TVExtraBranchView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 41) andBranch:_branch withViewController:self];
            _extraBranchView.scrollView=_scrollView;
            [self.view addSubview:_extraBranchView];
        }
    }
    
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    heightDefaultScroll=_imgBranchCover.frame.origin.y;
    sizeHeightDefaultScroll=_imgBranchCover.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    void *context = (__bridge void *)self;
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:context];
}

#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	// Make sure we are observing this value.
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
    if ((object == self.scrollView) &&
        ([keyPath isEqualToString:@"contentOffset"] == YES)) {
        [self scrollViewDidScrollWithOffset:self.scrollView.contentOffset.y];
        return;
    }
}

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
    //    NSLog(@"scrollOffset=%f",scrollOffset);
    if (scrollOffset>0) {
        CGRect frame= _imgBranchCover.frame;
        frame.origin.y=heightDefaultScroll-scrollOffset*.8;
        _imgBranchCover.frame=frame;
    }else{
        CGRect frame= _imgBranchCover.frame;
        frame.size.height=sizeHeightDefaultScroll-scrollOffset*.8;
        _imgBranchCover.frame=frame;
    }
}

#pragma mark - Helper




- (void)addSpecPointViewWithHeight:(int)height
{
    _introducingView=[[UIView alloc] initWithFrame:CGRectMake(7,height, 310, 10)];
    [_introducingView setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=_introducingView.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:1.0];
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    
    UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 19, 210, 23)];
    [self settingTextForTitle:lblTitle];
    lblTitle.text=@"Giới thiệu";
    [_introducingView addSubview:lblTitle];
    UIImageView* imageLine=[[UIImageView alloc] initWithFrame:CGRectMake(5, 19+23, 295, 3)];
    [imageLine setImage:[UIImage imageNamed:@"img_profile_branch_line"]];
    [_introducingView addSubview:imageLine];
    int lineHeight=imageLine.frame.origin.y+imageLine.frame.size.height +17;
    //    int lineHeight=50;
    [_scrollView addSubview:_introducingView];
    if (_branch.review) {
        NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
        //    NSLog(@"%@",_coupon.content);
        //continue building the string
        [html appendString:_branch.review];
        [html appendString:@"</body></html>"];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, lineHeight, 310, 25)];
        [webView.scrollView setScrollEnabled:NO];
        //make the background transparent
        [webView setBackgroundColor:[UIColor clearColor]];
        
        //pass the string to the webview
        [webView loadHTMLString:[html description] baseURL:nil];
        
        //add it to the subview
        [webView sizeToFit];
        // assuming your self.viewer is a UIWebView
        [webView setDelegate:self];
        [webView setAlpha:0.0];
        [_introducingView addSubview:webView];
    }else if(_branch.special_content)
    {
        for (NSString* str in _branch.special_content) {
            
            UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(8.0+15, lineHeight, 265, 25)];
            lblAddress.backgroundColor = [UIColor clearColor];
            lblAddress.textColor = [UIColor grayColor];
            lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(12)];
            lblAddress.text=str;
            [lblAddress resizeToStretch];
            [_introducingView addSubview:lblAddress];
            
            UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, lineHeight, 15, 15)];
            homeIcon.image=[UIImage imageNamed:@"img_camera_cell_button"];
            [_introducingView addSubview:homeIcon];
            lineHeight+=lblAddress.frame.size.height+5;
        }
        CGRect frame=_introducingView.frame;
        frame.size.height+=lineHeight;
        _introducingView.frame=frame;
        
        [_scrollView setContentSize:CGSizeMake(320,_introducingView.frame.origin.y+ _introducingView.frame.size.height+50)];
    }
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView setAlpha:1.0];
    CGRect newBounds = webView.frame;
    newBounds.size.height = webView.scrollView.contentSize.height;
    webView.frame = newBounds;
    
    CGRect frame=_introducingView.frame;
    frame.size.height+=newBounds.size.height;
    _introducingView.frame=frame;
    [_scrollView addSubview:_introducingView];
    [_scrollView setContentSize:CGSizeMake(320,_introducingView.frame.origin.y+ _introducingView.frame.size.height+50)];
    
}
- (void)setRowWithHeight:(int *)heightDetailInfo_p detailInfoBranch:(UIView *)detailInfoBranch strDetail:(NSString *)strDetail strTiltle:(NSString *)strTiltle
{
    if (strDetail) {
        UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, *heightDetailInfo_p, detailInfoBranch.frame.size.width, 1.0f)];
        grayLine.backgroundColor = [UIColor colorWithRed:(243/255.0f) green:(243/255.0f) blue:(243/255.0f) alpha:1.0f];
        [detailInfoBranch addSubview:grayLine];
        
        UILabel *lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(8, grayLine.frame.origin.y+grayLine.frame.size.height+5.0, 150, 23)];
        lblTitleRow.backgroundColor = [UIColor clearColor];
        lblTitleRow.textColor = [UIColor grayColor];
        lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblTitleRow.text =strTiltle;
        [detailInfoBranch addSubview:lblTitleRow];
        
        UILabel *lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(138, grayLine.frame.origin.y+grayLine.frame.size.height+ 5.0, 165, 23)];
        
        lblDetailRow.backgroundColor = [UIColor clearColor];
        lblDetailRow.textColor = [UIColor blackColor];
        lblDetailRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblDetailRow.text = strDetail;
        [lblDetailRow resizeToStretch];
        [detailInfoBranch addSubview:lblDetailRow];
        *heightDetailInfo_p+=14+lblDetailRow.frame.size.height;
    }
}

- (NSString*)getDetailStringFrom:(NSDictionary *)dic
{
    NSString* strStyleFoody;
    if ([[dic allValues] count]>0) {
        strStyleFoody=@"";
        BOOL isFistTime=YES;
        for (NSDictionary* dicStyle in [dic allValues]) {
            NSString* strStyleFoodyRow=@"";
            strStyleFoodyRow=[dicStyle valueForKey:@"name"];
            if (isFistTime) {
                isFistTime=NO;
                strStyleFoody=[strStyleFoody stringByAppendingFormat:@"%@",strStyleFoodyRow];
            }else
                strStyleFoody=[strStyleFoody stringByAppendingFormat:@", %@",strStyleFoodyRow];
        }
    }
    return strStyleFoody;
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
-(void)btnSMSButtonClicked:(UIButton*)sender{
    if([MFMessageComposeViewController canSendText]) {
        TVCoupon* coupon=_branch.coupons.items[sender.tag];
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.body = [NSString stringWithFormat:@"coupon [%@]",coupon.syntax];
        picker.recipients = [NSArray arrayWithObjects:SMS_NUMBER, nil];
        picker.messageComposeDelegate = self;
        [self.navigationController    presentModalViewController:picker animated:YES];
    }
}

-(void)shareButtonClicked:(id)s{
    SearchWithContactsVC *viewController = [[SearchWithContactsVC alloc] initWithSectionIndexes:YES withParam:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)viewDetailCouponClicked:(UIButton*)sender{
    TVCoupon* coupon=_branch.coupons.items[sender.tag];
    CoupBranchProfileVC* specBranchVC=[[CoupBranchProfileVC alloc] initWithNibName:@"CoupBranchProfileVC" bundle:nil];
    specBranchVC.branch=_branch;
    specBranchVC.coupon=coupon;
    [self.navigationController pushViewController:specBranchVC animated:YES];
}

-(void)likeButtonClicked:(UIButton*)sender{
    
    
    if ([GlobalDataUser sharedAccountClient].isLogin){
        sender.userInteractionEnabled=NO;
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [GlobalDataUser sharedAccountClient].user.userId,@"user_id" ,
                                _branch.branchID,@"branch_id",
                                nil];
        NSLog(@"%@",params);
        [[TVNetworkingClient sharedClient] postPath:@"branch/userFavouriteBranch" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSLog(@"%@",JSON);
            [SVProgressHUD showSuccessWithStatus:@"Bạn vừa thích nhà hàng này!"];
            sender.userInteractionEnabled=YES;
            [FacebookServices checkFacebookSessionIsOpen:^(bool isOpen){
                if (isOpen) {
                    [FacebookServices postFollowActionWithBranch:_branch];
                }else{
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Bạn muốn kết nối với facebook để chia sẻ địa điểm này với mọi người"];
                    
                    [alertView addButtonWithTitle:@"Kết nối facebook"
                                             type:SIAlertViewButtonTypeDefault
                                          handler:^(SIAlertView *alert) {
                                              [FacebookServices loginAndTakePermissionWithHanlder:^(FBSession *session,NSError *error){
                                                  if (!error) {
                                                      [FacebookServices postFollowActionWithBranch:_branch];
                                                  }
                                              }];
                                              
                                          }];
                    [alertView addButtonWithTitle:@"Cancel"
                                             type:SIAlertViewButtonTypeCancel
                                          handler:^(SIAlertView *alert) {
                                              NSLog(@"Cancel Clicked");
                                          }];
                    [alertView show];
                }
            }];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            sender.userInteractionEnabled=YES;
            [SVProgressHUD showErrorWithStatus:@"Có lỗi khi like nhà hàng"];
            NSLog(@"%@",error);
        }];
    }else{
        [SharedAppDelegate.menuVC showLoginScreenWhenUserNotLogin:self.navigationController];
    }
}

-(void)commentButtonClicked:(id)sender{
    [SharedAppDelegate.menuVC commentButtonClickedWithNav:self.navigationController andWithBranch:_branch];
}

-(void)cameraButtonClicked:(id)sender{
    [SharedAppDelegate.menuVC cameraButtonClickedWithNav:self.navigationController andWithBranch:_branch];
}

-(void)mapViewButtonClicked:(id)sender{
    
}

-(void)albumButtonClicked:(id)sender{
    TVPhotoBrowserVC* mbImagesVC;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        mbImagesVC = [[TVPhotoBrowserVC alloc] initWithNibName:@"TMViewController_iPhone" bundle:nil] ;
    } else {
        mbImagesVC = [[TVPhotoBrowserVC alloc] initWithNibName:@"TMViewController_iPad" bundle:nil] ;
    }
    mbImagesVC.branch=_branch;
    UINavigationController* navController = [[UINavigationController    alloc] initWithRootViewController:mbImagesVC];
    navController.navigationBar.tintColor = [UIColor clearColor];
    navController.navigationBar.alpha = 0.7f;
    navController.navigationBar.translucent = YES;
    [self presentModalViewController:navController animated:YES];
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
