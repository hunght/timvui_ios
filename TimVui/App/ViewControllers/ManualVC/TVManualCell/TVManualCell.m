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
    UIView* couponBranch=[[UIView alloc] initWithFrame:CGRectMake(6, 6, 320-6*2, 110)];
    [couponBranch setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=couponBranch.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    [self.contentView addSubview:couponBranch];
    
    self.textLabel.frame=CGRectMake(10.0, 19, 210, 23);
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor redColor];
    self.textLabel.font = [UIFont fontWithName:@"UVNVanBold" size:(20)];
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    [self.contentView setBackgroundColor:[UIColor grayColor]];
    int height=self.textLabel.frame.origin.y+self.textLabel.frame.size.height;
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(6+5, height, 320-(6+5)*2, 100)];
    
    return self;
}



#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
