
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

#import "TVEventCell.h"
#import "TVBranch.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utilities.h"
#import "TVAppDelegate.h"
#import "UILabel+DynamicHeight.h"
#import "TVEvent.h"

@implementation TVEventCell {
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
    _imgCoverEvent=[[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5, 310, 140)];
    _lblNameBranch=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 250, 20.0f)];
    _lblTime=[[UILabel alloc] initWithFrame:CGRectMake(50.0f, 25.0f, 250, 20)];
    
    _lblContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 290, 20.0f)];
    _lblContent.backgroundColor = [UIColor clearColor];
    _lblContent.textColor = [UIColor blackColor];
    _lblContent.font =  [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    
    _lblTime.textColor = [UIColor colorWithRed:(149/255.0f) green:(149/255.0f) blue:(149/255.0f) alpha:1.0f];
    _lblTime.backgroundColor=[UIColor clearColor];
    _lblTime.font = [UIFont fontWithName:@"ArialMT" size:(11)];
    
    _lblNameBranch.textColor = [UIColor colorWithRed:(1/255.0f) green:(144/255.0f) blue:(218/255.0f) alpha:1.0f];
    _lblNameBranch.backgroundColor=[UIColor clearColor];
    _lblNameBranch.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    
    // Get the Layer of any view
    [self.imgCoverEvent addSubview:_lblContent];
    [self.imgCoverEvent addSubview:_lblNameBranch];
    [self.imgCoverEvent addSubview:_lblTime];
    
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    return self;
}

- (void)setEvent:(TVEvent *)event{
    _lblNameBranch.text=event.branch.name;
    _lblTime.text =event.branch.address_full;
    _lblContent.text=event.title;
    [_lblContent resizeToStretch];
    
    CGRect frame=    _lblNameBranch.frame;
    int padHeight=    frame.origin.y;
    frame.origin.y=_lblContent.frame.origin.y+_lblContent.frame.size.height+15;
    _lblNameBranch.frame=frame;
    padHeight=frame.origin.y-padHeight;
    
    
    frame= _lblContent.frame;
    frame.origin.x-=5;
    frame.origin.y-=5;
    frame.size.width+=10;
    frame.size.height+=10;
    

    frame= _lblTime.frame;
    frame.origin.y+=padHeight;
    _lblTime.frame=frame;
    
    frame= _imgCoverEvent.frame;
    frame.origin.y+=padHeight;
    _imgCoverEvent.frame=frame;
    
    //    NSLog(@"[arrCoupons count]===%@",_coupon.branch.arrURLImages);
    [_imgCoverEvent setImageWithURL:[Utilities getThumbImageOfCoverBranch:event.branch.arrURLImages]placeholderImage:[UIImage imageNamed:@"branch_placeholder"]];
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(TVEvent *)event {
    CGSize maximumLabelSize = CGSizeMake(210.0f,9999);
    UIFont *cellFont = [UIFont fontWithName:@"ArialMT" size:(13)];
    CGSize expectedLabelSize = [event.branch.address_full sizeWithFont:cellFont
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
    [super layoutSubviews];
    
}

@end
