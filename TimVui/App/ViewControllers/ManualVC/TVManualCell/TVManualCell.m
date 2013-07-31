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
#import "Utilities.h"
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
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(10.0, 10, 300, 23)];
    self.lblTitle.backgroundColor = [UIColor clearColor];
    self.lblTitle.textColor = [UIColor blackColor];
    self.lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
    self.lblTitle.numberOfLines = 0;
    self.lblTitle.lineBreakMode = UILineBreakModeWordWrap;
    [self.contentView    addSubview:self.lblTitle];
    
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(6+5, 170, 320-(6+5)*2, 100)];
    [self.webView.scrollView setScrollEnabled:NO];
    _webView.opaque = NO;

    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.webView];

    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 150, 34)];
    [_saveButton setTitle:@"Lưu lại" forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(3/255.0f) green:(190/255.0f) blue:(239/255.0f) alpha:1.0f]] forState:UIControlStateNormal];
    
    [_saveButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(71/255.0f) green:(217/255.0f) blue:(255/255.0f) alpha:1.0f]] forState:UIControlStateSelected];

    [self.contentView addSubview:_saveButton];
    
    _detailButton = [[UIButton alloc] initWithFrame:CGRectMake(150+5, 0, 150, 34)];
    [_detailButton setTitle:@"Chi tiết" forState:UIControlStateNormal];
    [_detailButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(3/255.0f) green:(190/255.0f) blue:(239/255.0f) alpha:1.0f]] forState:UIControlStateNormal];
    
    [_detailButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(71/255.0f) green:(217/255.0f) blue:(255/255.0f) alpha:1.0f]] forState:UIControlStateSelected];
    [self.contentView addSubview:_detailButton];

    
    _imgView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 295, 170)];
    [self.contentView addSubview:_imgView];
    
    UIView* bgImageView=[[UIView alloc] initWithFrame:CGRectMake(0, 140, 295, 30)];
    [bgImageView setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:.4f]];
    
    UIImageView* imgEye=[[UIImageView alloc] initWithFrame:CGRectMake(12,2, 12, 8)];
    [imgEye setImage:[UIImage imageNamed:@"img_handbook_eye"]];
    _viewCountDate=[[UIView alloc] initWithFrame:CGRectMake(5, 0, 320, 16)];
    [self.contentView addSubview:_viewCountDate];
    [_viewCountDate addSubview:imgEye];
    
    UIImageView* imgDate=[[UIImageView alloc] initWithFrame:CGRectMake(65,0, 12, 12)];
    [imgDate setImage:[UIImage imageNamed:@"img_handbook_clock"]];
    [_viewCountDate addSubview:imgDate];
    
    _lblView=[[UILabel alloc] initWithFrame:CGRectMake(30, 1, 40, 12)];
    [_lblView setBackgroundColor:[UIColor clearColor]];
    [_lblView setTextColor:[UIColor grayColor]];
    _lblView.font = [UIFont fontWithName:@"ArialMT" size:(10)];
    [self.viewCountDate addSubview:_lblView];
    
    _lblDate=[[UILabel alloc] initWithFrame:CGRectMake(83, 1, 80, 12)];
    [_lblDate setBackgroundColor:[UIColor clearColor]];
    [_lblDate setTextColor:[UIColor grayColor]];
    _lblDate.font = [UIFont fontWithName:@"ArialMT" size:(10)];
    [self.viewCountDate addSubview:_lblDate];
    
    [self.imgView addSubview:bgImageView];
    
    _lblTags=[[UILabel alloc] initWithFrame:CGRectMake(0, 140, 295, 30)];
    [_lblTags setBackgroundColor:[UIColor clearColor]];
    [_lblTags setTextColor:[UIColor whiteColor]];
    _lblTags.font = [UIFont fontWithName:@"ArialMT" size:(10)];
    [self.imgView addSubview:_lblTags];
    
    return self;
}

#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];
}
+ (CGFloat)sizeExpectedWithText:(NSString *)branch {
    CGSize maximumLabelSize = CGSizeMake(300.0f,9999);
    UIFont *cellFont = [UIFont fontWithName:@"ArialMT" size:(15)];
    CGSize expectedLabelSize = [branch sizeWithFont:cellFont
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:NSLineBreakByWordWrapping];
    return expectedLabelSize.height;
}

@end
