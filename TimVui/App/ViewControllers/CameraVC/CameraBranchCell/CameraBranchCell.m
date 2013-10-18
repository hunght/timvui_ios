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

#import "CameraBranchCell.h"
#import "TVBranch.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utilities.h"
#import "TVAppDelegate.h"
#import "UILabel+DynamicHeight.h"
int cellPad=44;
@implementation CameraBranchCell {
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
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern_menu"]];
    [self setSelectedBackgroundView:bgView];
    
    _lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 30.0f, 210.0f-cellPad, 20.0f)];
    _lblDetailRow.backgroundColor = [UIColor clearColor];
    _lblDetailRow.textColor = [UIColor blackColor];
    _lblDetailRow.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor redColor];

    self.textLabel.backgroundColor=[UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.textLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];

    UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 35.0, 11, 12)];
    homeIcon.image=[UIImage imageNamed:@"img_address_branch_icon"];
    

    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(80.0, 8.0, 234-cellPad, 0)];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];
    // Get the Layer of any view
    CALayer * l = [_whiteView layer];
    [self setBorderForLayer:l radius:3];
    
    l = [self.imageView layer];
    [self setBorderForLayer:l radius:1];
    [_whiteView addSubview:self.textLabel];
    [_whiteView addSubview:homeIcon];
    [self.whiteView addSubview:_lblDetailRow];
    [self.contentView addSubview:_whiteView];
    [self.contentView setBackgroundColor:[UIColor colorWithRed:(239/255.0f) green:(239/255.0f) blue:(239/255.0f) alpha:1.0f]];
    return self;
}

- (void)setBranch:(TVBranch *)branch {
    _branch = branch;
    self.textLabel.text=_branch.name;

    _lblDetailRow.text =_branch.address_full;
    [_lblDetailRow resizeToStretch];
    CGRect frame=_whiteView.frame;
    frame.size.height=_lblDetailRow.frame.origin.y+_lblDetailRow.frame.size.height+5;
    _whiteView.frame=frame;

    [self.imageView setImageWithURL:[Utilities getThumbImageOfCoverBranch:_branch.arrURLImages]placeholderImage:[UIImage imageNamed:@"branch_placeholder"]];
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(TVBranch *)branch {
    CGSize maximumLabelSize = CGSizeMake(210.0f-cellPad,9999);
    UIFont *cellFont = [UIFont fontWithName:@"ArialMT" size:(13)];
    CGSize expectedLabelSize = [branch.address_full sizeWithFont:cellFont
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:NSLineBreakByWordWrapping];
    return expectedLabelSize.height+ 8+ 36+8;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5.0f, 8.0f, 70.0f, 70.0f);
    self.textLabel.frame = CGRectMake(10.0f, 8.0f, 222.0f-cellPad, 20.0f);
    
}

@end
