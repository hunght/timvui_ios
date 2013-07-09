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

#import "ExtraMenuCell.h"
#import "TVComment.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Ultilities.h"
#import "TVAppDelegate.h"
#import "NSDate+Helper.h"
@implementation ExtraMenuCell {
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
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor blackColor];

    self.textLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.detailTextLabel.textColor=[UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.detailTextLabel.textAlignment = UITextAlignmentCenter;
    self.textLabel.font = [UIFont fontWithName:@"UVNVanBold" size:(15)];
    self.detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    self.imageView.image=[UIImage imageNamed:@"img_map_coupon_event_icon_cell"];
    [self.contentView insertSubview:self.detailTextLabel aboveSubview:self.imageView];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    return self;
}



#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(254.0f, 8.0f, 56.0f, 17.0f);
    self.textLabel.frame = CGRectMake(15.0f, 8.0f, 222.0f, 15.0f);
    self.detailTextLabel.frame = CGRectMake(254.0f, 8.0f, 56.0f, 17.0f);
}

@end
