// TweetTableView_m
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
#import "NSDate-Utilities.h"
#import "TVManual.h"
#import "UILabel+DynamicHeight.h"
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
    self.lblDesc=[[UILabel alloc] initWithFrame:CGRectMake(15, 170, 320-(6+5)*2, 100)];
    self.lblDesc.font = [UIFont fontWithName:@"ArialMT" size:(15)];
    self.lblDesc.numberOfLines = 0;
    self.lblDesc.lineBreakMode = UILineBreakModeWordWrap;
    [self.lblDesc setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.lblDesc];

    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 150, 34)];
    [_saveButton setTitle:@"Lưu lại" forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[Utilities imageFromColor:kCyanGreenColor] forState:UIControlStateNormal];
    
    [_saveButton setBackgroundImage:[Utilities imageFromColor:kPaleCyanGreenColor] forState:UIControlStateSelected];

    [self.contentView addSubview:_saveButton];
    
    _detailButton = [[UIButton alloc] initWithFrame:CGRectMake(150+5, 0, 150, 34)];
    [_detailButton setTitle:@"Chi tiết" forState:UIControlStateNormal];
    [_detailButton setBackgroundImage:[Utilities imageFromColor:kCyanGreenColor] forState:UIControlStateNormal];
    
    [_detailButton setBackgroundImage:[Utilities imageFromColor:kPaleCyanGreenColor] forState:UIControlStateSelected];
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

-(void)setManual:(TVManual*)manual{
    _lblTitle.text=manual.title;
    [_lblTitle resizeToStretch];
    
    int height=_lblTitle.frame.origin.y+_lblTitle.frame.size.height;
    CGRect frame=_imgView.frame;
    frame.origin.y=height+5;
    [_imgView setFrame:frame];
    [_imgView setImageWithURL:[NSURL URLWithString:manual.images]];
    
    height=_imgView.frame.origin.y+_imgView.frame.size.height;
    frame=_viewCountDate.frame;
    frame.origin.y=height+5;
    [_viewCountDate setFrame:frame];
    
    height=_viewCountDate.frame.origin.y+_viewCountDate.frame.size.height;
    
    [_lblDesc setText:manual.desc];
    [_lblDesc resizeToStretch];
    frame=_lblDesc.frame;
    frame.origin.y=height;
    [_lblDesc setFrame:frame];
    
    height=_lblDesc.frame.origin.y+_lblDesc.frame.size.height;
    frame=_saveButton.frame;
    frame.origin.y=height+15;
    _saveButton.frame=frame;
    
    frame=_detailButton.frame;
    frame.origin.y=height+15;
    _detailButton.frame=frame;
    

    
    _lblView.text=manual.view;
    _lblDate.text=[manual.changed stringWithFormat:@"dd/mm/yyyy"];
    
    NSString* tempStrName=@"";
    BOOL isFirst=YES;
    for (NSString* str in [manual.cities valueForKey:@"name"]) {
        if (isFirst) {
            isFirst=NO;
            tempStrName=[tempStrName stringByAppendingFormat:@"  %@",str];
        }else
            tempStrName=[tempStrName stringByAppendingFormat:@", %@",str];
    }
    
    tempStrName=[tempStrName stringByAppendingString:@"|"];
    isFirst=YES;
    for (NSString* str in [manual.handbook_cat valueForKey:@"name"]) {
        if (isFirst) {
            isFirst=NO;
            tempStrName=[tempStrName stringByAppendingFormat:@"%@",str];
        }else
            tempStrName=[tempStrName stringByAppendingFormat:@", %@",str];
    }
    
    _lblTags.text=[NSString stringWithFormat:@"%@",tempStrName];
}


+ (CGFloat)sizeExpectedWithText:(NSString *)branch andDesc:(NSString*)desc{
    CGSize maximumLabelSize = CGSizeMake(300.0f,9999);
    UIFont *cellFont =[UIFont fontWithName:@"Arial-BoldMT" size:(15)];
    CGSize expectedLabelSize = [branch sizeWithFont:cellFont
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    maximumLabelSize=CGSizeMake(320-(6+5)*2, 9999);
    cellFont =[UIFont fontWithName:@"ArialMT" size:(15)];
    CGSize expectedLabelDescSize = [desc sizeWithFont:cellFont
                                  constrainedToSize:maximumLabelSize
                                      lineBreakMode:NSLineBreakByWordWrapping];
    return expectedLabelSize.height+expectedLabelDescSize.height;
}

@end
