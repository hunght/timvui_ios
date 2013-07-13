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

#import "TVManualCell.h"
#import "TVComment.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Ultilities.h"
#import "TVAppDelegate.h"
#import "NSDate+Helper.h"
@implementation TVManualCell {
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
    UIView* couponBranch=[[UIView alloc] initWithFrame:CGRectMake(6, 6, 320-6*2, 360)];
    [couponBranch setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=couponBranch.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    [self.contentView addSubview:couponBranch];
    
    self.lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(10.0, 5, 300, 23)];
    self.lblTitle.backgroundColor = [UIColor clearColor];
    self.lblTitle.textColor = [UIColor redColor];
    self.lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
    self.lblTitle.numberOfLines = 0;
    self.lblTitle.lineBreakMode = UILineBreakModeWordWrap;
    [couponBranch addSubview:self.lblTitle];
    
    [self.contentView setBackgroundColor:[UIColor grayColor]];

    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(6+5, 0, 320-(6+5)*2, 270)];
    [self.webView.scrollView setScrollEnabled:NO];
    
    [couponBranch addSubview:self.webView];   

    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 150, 44)];
    [_saveButton setTitle:@"Lưu lại" forState:UIControlStateNormal];
//    [_saveButton setImage:[UIImage imageNamed:@"img_button-menu-on"] forState:UIControlStateNormal];
//    [_saveButton setImage:[UIImage imageNamed:@"img_button-menu-off"] forState:UIControlStateHighlighted];
    [_saveButton setBackgroundColor:[UIColor grayColor]];
    [couponBranch addSubview:_saveButton];
    
    _detailButton = [[UIButton alloc] initWithFrame:CGRectMake(150+5, 0, 150, 44)];
    [_detailButton setTitle:@"Chi tiết" forState:UIControlStateNormal];
    //[_detailButton setImage:[UIImage imageNamed:@"img_button-menu-on"] forState:UIControlStateNormal];
    //    [_detailButton setImage:[UIImage imageNamed:@"img_button-menu-off"] forState:UIControlStateHighlighted];
    [_detailButton setBackgroundColor:[UIColor grayColor]];
    [couponBranch addSubview:_detailButton];
    
    return self;
}



#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
