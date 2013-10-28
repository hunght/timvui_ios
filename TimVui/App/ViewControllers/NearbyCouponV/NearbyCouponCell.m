
// TweetTableViewCell.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NearbyCouponCell.h"
#import "TVBranch.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "Utilities.h"
#import "TVAppDelegate.h"
#import "UILabel+DynamicHeight.h"
#import "TVCoupon.h"
#import "NSDate-Utilities.h"


@implementation NearbyCouponCell {
    UILabel *lblViewNumber ;
    UILabel *lblNumOfCoupon;
    UIImageView* coverImage;
}


- (void)setBorderForLayer:(CALayer *)l radius:(float)radius {
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 1)];
    grayLine.backgroundColor = [UIColor colorWithRed:(243/255.0f) green:(243/255.0f) blue:(243/255.0f) alpha:1.0f];
    [self.contentView addSubview:grayLine];
    
    _avatarBranch=[[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5, 40, 40)];
    _lblNameBranch=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 250, 20.0f)];
    _lblAddressBranch=[[UILabel alloc] initWithFrame:CGRectMake(50.0f, 25.0f, 250, 20)];
    
    _lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, 220, 20.0f)];
    _lblDetailRow.backgroundColor = [UIColor clearColor];
    _lblDetailRow.textColor = [UIColor whiteColor];
    _lblDetailRow.font =  [UIFont fontWithName:@"ArialMT" size:(13)];

    _lblAddressBranch.textColor = [UIColor colorWithRed:(149/255.0f) green:(149/255.0f) blue:(149/255.0f) alpha:1.0f];
    _lblAddressBranch.backgroundColor=[UIColor clearColor];
    _lblAddressBranch.font = [UIFont fontWithName:@"ArialMT" size:(11)];

    _lblNameBranch.textColor = [UIColor colorWithRed:(1/255.0f) green:(144/255.0f) blue:(218/255.0f) alpha:1.0f];
    _lblNameBranch.backgroundColor=[UIColor clearColor];
    _lblNameBranch.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    
    UIView* _whiteView = [[UIView alloc] initWithFrame:CGRectMake(15, 150, 290, 45)];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];

    UIView* borderView=[[UIView alloc] initWithFrame:CGRectMake(10 ,5 , 290, 144)];
    [borderView setBackgroundColor:[UIColor grayColor]];
    coverImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 144)];
    [borderView addSubview:coverImage];
    
    
    UIImageView* img_coupon_gradient=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 83)];
    img_coupon_gradient.image=[UIImage imageNamed:@"img_coupon_gradient"];
    
    UIImageView* img_coupon_hot=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 57, 56)];
    img_coupon_hot.image=[UIImage imageNamed:@"img_coupon_hot"];
    [borderView addSubview:img_coupon_gradient];
    [borderView addSubview:img_coupon_hot];
    
    [borderView addSubview:_lblDetailRow];

    [self.contentView addSubview:borderView];
    
    [_whiteView addSubview:_lblNameBranch];
    [_whiteView addSubview:_avatarBranch];
    [_whiteView addSubview:_lblAddressBranch];
    [self.contentView addSubview:_whiteView];

    
    //View for info branch
    UIView* infoCouponBranch=[[UIView alloc] initWithFrame:CGRectMake(0, 120, 290, 24)];
    [infoCouponBranch setBackgroundColor:[UIColor colorWithWhite:1 alpha:.9]];
    
    UIImageView* quatityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(18.0, 5+ 3, 14, 12)];
    quatityIcon.image=[UIImage imageNamed:@"img_profile_branch_quatity_coupon"];
    [infoCouponBranch addSubview:quatityIcon];
    
    UILabel *lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(35, 5.0, 60, 16)];
    lblTitleRow.backgroundColor = [UIColor clearColor];
    lblTitleRow.textColor = [UIColor grayColor];
    lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    lblTitleRow.text =@"Số lượng";
    [infoCouponBranch addSubview:lblTitleRow];
    
    
    lblNumOfCoupon = [[UILabel alloc] initWithFrame:CGRectMake(90, 5.0, 150, 16)];
    lblNumOfCoupon.backgroundColor = [UIColor clearColor];
    lblNumOfCoupon.textColor = [UIColor grayColor];
    lblNumOfCoupon.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    
    [infoCouponBranch addSubview:lblNumOfCoupon];
    
    quatityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(152, 5+ 3, 14, 10)];
    quatityIcon.image=[UIImage imageNamed:@"img_profile_branch_view_number"];
    [infoCouponBranch addSubview:quatityIcon];
    
    lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(170, 5.0, 150, 16)];
    lblTitleRow.backgroundColor = [UIColor clearColor];
    lblTitleRow.textColor = kGrayTextColor;
    lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12+1)];
    lblTitleRow.text =@"Lượt xem";
    [infoCouponBranch addSubview:lblTitleRow];
    
    lblViewNumber = [[UILabel alloc] initWithFrame:CGRectMake(230, 5.0, 150, 16)];
    lblViewNumber.backgroundColor = [UIColor clearColor];
    lblViewNumber.textColor = [UIColor grayColor];
    lblViewNumber.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    
    [infoCouponBranch addSubview:lblViewNumber];
    
    
    [borderView addSubview:infoCouponBranch];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    return self;
}

- (void)setCoupon:(TVCoupon *)_coupon {
    lblViewNumber.text =_coupon.view;
    lblNumOfCoupon.text =_coupon.use_number;
    
    _lblNameBranch.text=_coupon.branch.name;
    _lblAddressBranch.text =_coupon.branch.address_full;
    _lblDetailRow.text=_coupon.name;
    [_lblDetailRow resizeToStretch];
    [coverImage setImageWithURL:[NSURL URLWithString:_coupon.image]];
    
    
//    NSLog(@"[arrCoupons count]===%@",_coupon.image);
    [_avatarBranch setImageWithURL:[Utilities getThumbImageOfCoverBranch:_coupon.branch.arrURLImages]placeholderImage:[UIImage imageNamed:@"branch_placeholder"]];
    [self setNeedsLayout];
}



#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];

}

@end
