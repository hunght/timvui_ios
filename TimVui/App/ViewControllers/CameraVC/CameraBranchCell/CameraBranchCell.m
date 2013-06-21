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
#import "Ultilities.h"
#import "TVAppDelegate.h"
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
    _lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 30.0f, 210.0f-cellPad, 20.0f)];
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor redColor];

    self.textLabel.backgroundColor=[UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    self.textLabel.font = [UIFont fontWithName:@"UVNVanBold" size:(15)];

    
    
    UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 35.0, 11, 12)];
    homeIcon.image=[UIImage imageNamed:@"img_address_branch_icon"];
    

    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(80.0, 8.0, 234-cellPad, 96)];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];
    // Get the Layer of any view
    CALayer * l = [_whiteView layer];
    [self setBorderForLayer:l radius:3];
    
    l = [self.imageView layer];
    [self setBorderForLayer:l radius:1];
    [_whiteView addSubview:self.textLabel];
    [_whiteView addSubview:homeIcon];
    
    [self.contentView addSubview:_whiteView];
    [self.contentView setBackgroundColor:[UIColor colorWithRed:(239/255.0f) green:(239/255.0f) blue:(239/255.0f) alpha:1.0f]];
    return self;
}

- (void)setBranch:(TVBranch *)branch {
    _branch = branch;
    self.textLabel.text=_branch.name;
    
    
    _lblDetailRow.backgroundColor = [UIColor clearColor];
    _lblDetailRow.textColor = [UIColor blackColor];
    _lblDetailRow.numberOfLines = 0;
    _lblDetailRow.lineBreakMode = UILineBreakModeWordWrap;
    _lblDetailRow.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    _lblDetailRow.text =_branch.address_full;
    [_lblDetailRow sizeToFit];
    [self.whiteView addSubview:_lblDetailRow];

    [self.imageView setImageWithURL:[Ultilities getThumbImageOfCoverBranch:_branch.arrURLImages]placeholderImage:[UIImage imageNamed:@"branch_placeholder"]];
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(TVBranch *)branch {
    CGSize maximumLabelSize = CGSizeMake(210.0f-cellPad,9999);
    UIFont *cellFont = [UIFont fontWithName:@"ArialMT" size:(13)];
    CGSize expectedLabelSize = [branch.address_full sizeWithFont:cellFont
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:NSLineBreakByWordWrapping];
    return expectedLabelSize.height+ 8+96+8;
}

#pragma mark - UIView
-(void)setFrame:(CGRect)frame {
    frame.size.width -=44;
    [super setFrame:frame];
}
- (void)layoutSubviews {
    CGRect b = [self bounds];
    b.size.width -= 30; // allow extra width to slide for editing
    b.origin.x = 0; // start 30px left unless editing
    [self.contentView setFrame:b];
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5.0f, 8.0f, 70.0f, 70.0f);
    self.textLabel.frame = CGRectMake(10.0f, 8.0f, 222.0f-cellPad, 20.0f);
    
}

@end