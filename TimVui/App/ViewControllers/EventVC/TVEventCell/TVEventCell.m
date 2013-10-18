
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
#import "NSDate-Utilities.h"
#import "UIImage+Crop.h"


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
    _lblTime=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 12)];
    
    _viewBgContent=[[UIView alloc] initWithFrame:CGRectMake(0, 140-45, 310, 45)];
    [_viewBgContent setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    
    _viewBgTime=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 125, 30)];
    [_viewBgTime setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    

    _lblContent = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(12, 105, 290, 30)];
    _lblContent.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    _lblContent.textColor = [UIColor whiteColor];
    _lblContent.lineBreakMode = UILineBreakModeWordWrap;
    _lblContent.numberOfLines = 2;
    _lblContent.backgroundColor=[UIColor clearColor];
    
    _lblTime.textColor = [UIColor whiteColor];
    _lblTime.backgroundColor=[UIColor clearColor];
    _lblTime.font = [UIFont fontWithName:@"ArialMT" size:(10)];
    

    // Get the Layer of any view
    [self.imgCoverEvent addSubview:_viewBgTime];
    [self.imgCoverEvent addSubview:_viewBgContent];
    [self.imgCoverEvent addSubview:_lblContent];
    [self.imgCoverEvent addSubview:_lblTime];
    _imgCoverEvent.contentMode=UIViewContentModeScaleToFill;
    [self.contentView addSubview:_imgCoverEvent];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    return self;
}

- (void)setEvent:(TVEvent *)event{
    NSDate* date =event.start;
    int weekday=[date weekday];
    NSString* strPresentDate=[date stringDayAhead];
    if (strPresentDate) {
        _lblTime.text=[NSString stringWithFormat:@"%@ %@",[date stringWithFormat:@"HH:mm"],strPresentDate];

    }else{
        _lblTime.text=(weekday!=8)?[NSString stringWithFormat:@"%@: T%d | %@",[date stringWithFormat:@"HH:mm"],weekday,[date stringWithFormat:@"dd/MM/yyyy"]]:[NSString stringWithFormat:@"%@: CN | %@",[date stringWithFormat:@"HH:mm"],[date stringWithFormat:@"dd/MM/yyyy"]];
    }
    [_lblTime resizeWidthToStretch];
    CGRect frame= _viewBgTime.frame;
    frame.size.width=_lblTime.frame.size.width+ 20;
    _viewBgTime.frame=frame;
    
    
    NSString* text = [NSString stringWithFormat:@"%@: %@",event.branch.name, event.title];
    [_lblContent setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
        UIFont *boldSystemFont = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];;
        NSRange whiteRange = [text rangeOfString:event.branch.name];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        
        if (whiteRange.location != NSNotFound) {
            // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor colorWithRed:(1/255.0f) green:(144/255.0f) blue:(218/255.0f) alpha:1.0f].CGColor range:whiteRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:whiteRange];
            CFRelease(font);
        }
        
        return mutableAttributedString;
    }];
    

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:event.image]
                    delegate:self
                     options:0
                     success:^(UIImage *image, BOOL cached)
     {
         image=[image imageByScalingAndCroppingForSize:CGSizeMake(310, 140)];
         [_imgCoverEvent setImage:image];

     }
         failure:nil];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
