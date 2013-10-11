
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
    UILabel *lblUsingTime;
    UIView* infoCouponBranch;
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
    _avatarBranch=[[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5, 40, 40)];
    _lblNameBranch=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 250, 20.0f)];
    _lblAddressBranch=[[UILabel alloc] initWithFrame:CGRectMake(50.0f, 25.0f, 250, 20)];
    
    _lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 290, 20.0f)];
    _lblDetailRow.backgroundColor = [UIColor clearColor];
    _lblDetailRow.textColor = [UIColor blackColor];
    _lblDetailRow.font =  [UIFont fontWithName:@"Arial-BoldMT" size:(13)];

    _lblAddressBranch.textColor = [UIColor colorWithRed:(149/255.0f) green:(149/255.0f) blue:(149/255.0f) alpha:1.0f];
    _lblAddressBranch.backgroundColor=[UIColor clearColor];
    _lblAddressBranch.font = [UIFont fontWithName:@"ArialMT" size:(11)];

    _lblNameBranch.textColor = [UIColor colorWithRed:(1/255.0f) green:(144/255.0f) blue:(218/255.0f) alpha:1.0f];
    _lblNameBranch.backgroundColor=[UIColor clearColor];
    _lblNameBranch.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(5, 8.0, 310, 96)];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];
    // Get the Layer of any view
    CALayer * l = [_whiteView layer];
    [self setBorderForLayer:l radius:1];
    
    l = [_avatarBranch layer];
    [self setBorderForLayer:l radius:1];
    
    _borderView=[[UIView alloc] initWithFrame:CGRectZero];
    [_borderView setBackgroundColor:[UIColor clearColor]];
    [self.whiteView addSubview:_borderView];
    [_whiteView addSubview:_lblNameBranch];
    [_whiteView addSubview:_avatarBranch];
    [self.whiteView addSubview:_lblDetailRow];
    [_whiteView addSubview:_lblAddressBranch];
    [self.contentView addSubview:_whiteView];
    _border = [CAShapeLayer layer];
    _border.strokeColor =[UIColor colorWithRed:(220/255.0f) green:(220/255.0f) blue:(220/255.0f) alpha:1.0f].CGColor;
    _border.fillColor = nil;
    _border.lineDashPattern = @[@4, @2];
    [_whiteView.layer addSublayer:_border];
    
    //View for info branch
    infoCouponBranch=[[UIView alloc] initWithFrame:CGRectMake(12, 0, 320-(6+5)*2, 45)];
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
    lblTitleRow.text =@"Lượt xem";
    [infoCouponBranch addSubview:lblTitleRow];
    
    lblViewNumber = [[UILabel alloc] initWithFrame:CGRectMake(150, 5.0, 150, 23)];
    lblViewNumber.backgroundColor = [UIColor clearColor];
    lblViewNumber.textColor = [UIColor grayColor];
    lblViewNumber.font = [UIFont fontWithName:@"ArialMT" size:(12)];

    [infoCouponBranch addSubview:lblViewNumber];
    
    UIImageView* viewNumberIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 25+ 3, 12, 11)];
    viewNumberIcon.image=[UIImage imageNamed:@"img_profile_branch_view_number"];
    [infoCouponBranch addSubview:viewNumberIcon];
    
    lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(50, 25.0, 150, 23)];
    lblTitleRow.backgroundColor = [UIColor clearColor];
    lblTitleRow.textColor = [UIColor grayColor];
    lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    lblTitleRow.text =@"Hạn sử dụng";
    [infoCouponBranch addSubview:lblTitleRow];
    
    lblUsingTime = [[UILabel alloc] initWithFrame:CGRectMake(150, 25.0, 150, 23)];
    lblUsingTime.backgroundColor = [UIColor clearColor];
    lblUsingTime.textColor = [UIColor grayColor];
    lblUsingTime.font = [UIFont fontWithName:@"ArialMT" size:(12)];

    [infoCouponBranch addSubview:lblUsingTime];
    
    [self.contentView addSubview:infoCouponBranch];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    return self;
}

- (void)setCoupon:(TVCoupon *)_coupon {
    lblViewNumber.text =_coupon.use_number;
    lblUsingTime.text =[NSString stringWithFormat:@"%@ - %@",[_coupon.start stringWithFormat:@"dd/MM/yy"], [_coupon.end stringWithFormat:@"dd/MM/yy"]];
    
    _lblNameBranch.text=_coupon.branch.name;
    _lblAddressBranch.text =_coupon.branch.address_full;
    _lblDetailRow.text=_coupon.name;
    [_lblDetailRow resizeToStretch];
    
    CGRect frame= infoCouponBranch.frame;
    frame.origin.y=_lblDetailRow.frame.origin.y+_lblDetailRow.frame.size.height+ 18;
    infoCouponBranch.frame=frame;
    
     frame=    _lblNameBranch.frame;
    int padHeight=    frame.origin.y;
    frame.origin.y=infoCouponBranch.frame.origin.y+infoCouponBranch.frame.size.height;
    _lblNameBranch.frame=frame;
    padHeight=frame.origin.y-padHeight;
    
    frame= _lblDetailRow.frame;
    frame.origin.x-=5;
    frame.origin.y-=5;
    frame.size.width+=10;
    frame.size.height+=10;

    // Setup the path
    _border.path = [UIBezierPath bezierPathWithRect:frame].CGPath;
    [_borderView setFrame:frame];
    _border.frame = _whiteView.bounds;
    
    [[_whiteView layer] addSublayer:_border];
    

    
    frame= _lblAddressBranch.frame;
    frame.origin.y+=padHeight;
    _lblAddressBranch.frame=frame;
    
    frame= _avatarBranch.frame;
    frame.origin.y+=padHeight;
    _avatarBranch.frame=frame;
    
    frame= _whiteView.frame;
    frame.size.height=_lblAddressBranch.frame.origin.y+_lblAddressBranch.frame.size.height+5;
    _whiteView.frame=frame;
    
//    NSLog(@"[arrCoupons count]===%@",_coupon.branch.arrURLImages);
    [_avatarBranch setImageWithURL:[Utilities getThumbImageOfCoverBranch:_coupon.branch.arrURLImages]placeholderImage:[UIImage imageNamed:@"branch_placeholder"]];
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(TVCoupon *)coupon {
    CGSize maximumLabelSize = CGSizeMake(290,9999);
    UIFont *cellFont = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    CGSize expectedLabelSize = [coupon.name sizeWithFont:cellFont
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:NSLineBreakByWordWrapping];
    return expectedLabelSize.height+ 8+66+8 +45;
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        [_borderView setBackgroundColor:[UIColor colorWithRed:(1/255.0f) green:(144/255.0f) blue:(218/255.0f) alpha:1.0f]];
        [_lblDetailRow setTextColor:[UIColor whiteColor]];
    }else{
        [_borderView setBackgroundColor:[UIColor clearColor]];
        [_lblDetailRow setTextColor:[UIColor blackColor]];
    }
    
}

#pragma mark - UIView
-(void)setFrame:(CGRect)frame {
    frame.size.width -=44;
    [super setFrame:frame];
}
- (void)layoutSubviews {
    [super layoutSubviews];

}

@end
