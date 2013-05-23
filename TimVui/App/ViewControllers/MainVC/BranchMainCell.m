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

#import "BranchMainCell.h"
#import "UIImageView+AFNetworking.h"
#import "TVBranch.h"
#import <QuartzCore/QuartzCore.h>
@implementation BranchMainCell {
@private
    __strong TVBranch *_branch;
}

@synthesize branch = _branch;

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
    self.textLabel.textColor = [UIColor redColor];

    self.detailTextLabel.numberOfLines = 1;
    self.textLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.backgroundColor=[UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.price_avg = [[UILabel alloc] initWithFrame:CGRectZero];
    self.price_avg.backgroundColor = [UIColor clearColor];
    
    self.price_avg.textColor = [UIColor grayColor];
    self.price_avg.highlightedTextColor = [UIColor whiteColor];
    
    
    self.textLabel.font = [UIFont fontWithName:@"UVNVanBold" size:(15)];
    self.price_avg.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    self.detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    
    
    UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 35.0, 11, 12)];
    homeIcon.image=[UIImage imageNamed:@"img_address_branch_icon"];
    
    UIImageView* price_avgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 53.0, 8, 11)];
    price_avgIcon.image=[UIImage imageNamed:@"img_price_range_branch_icon"];
    
    
    
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(80.0, 8.0, 234, 96)];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];
    // Get the Layer of any view
    CALayer * l = [_whiteView layer];
    [self setBorderForLayer:l radius:3];
    
    l = [self.imageView layer];
    [self setBorderForLayer:l radius:1];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 66.0f, 234.0f, 1.0f)];
    grayLine.backgroundColor = [UIColor colorWithRed:(239/255.0f) green:(239/255.0f) blue:(239/255.0f) alpha:1.0f];
    
    [_whiteView addSubview:grayLine];
    [_whiteView addSubview:self.textLabel];
    [_whiteView addSubview:self.detailTextLabel];
    [_whiteView addSubview:_price_avg];
    [_whiteView addSubview:homeIcon];
    [_whiteView addSubview:price_avgIcon];
    
    [self.contentView addSubview:_whiteView];
    return self;
}

- (void)setBranch:(TVBranch *)branch {
    _branch = branch;
    self.textLabel.text=_branch.name;
    self.detailTextLabel.text=_branch.address_full;
    self.price_avg.text=_branch.price_avg;
    [self.imageView setImageWithURL:[NSURL URLWithString:[_branch.arrURLImages valueForKey:@"80"]]
                   placeholderImage:[UIImage imageNamed:@"branch_placeholder"]];
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(TVBranch *)branch {
    return (8+96+8+branch.coupon_count*2);
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5.0f, 8.0f, 70.0f, 70.0f);
    self.textLabel.frame = CGRectMake(10.0f, 8.0f, 222.0f, 20.0f);
    self.detailTextLabel.frame = CGRectMake(25.0f, 30.0f, 210.0f, 20.0f);
    self.price_avg.frame = CGRectMake(25.0f, 48.0f, 210.0f, 20.0f);
    
}

@end
