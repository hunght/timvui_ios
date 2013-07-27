//
//  PageOneView.m
//  Anuong
//
//  Created by Hoang The Hung on 7/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PageTwoView.h"
#import "TVBranch.h"
//#import "NSDate+Helper.h"
#import "NSDate-Utilities.h"
@implementation PageTwoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setName:(NSString*)name andAddress:(NSString*)address{
    NSDate* date=[NSDate date];
    _lblTime.text=[[NSDate date] stringWithFormat:@"hh:mm a"];
    _lblDate.text=[NSString stringWithFormat:@"T.%d:%d-%d",[date weekday],[date day],[date month]];

    _lblBranchName.backgroundColor = [UIColor clearColor];
    _lblBranchName.textColor = [UIColor whiteColor];
    _lblBranchName.numberOfLines = 0;
    _lblBranchName.lineBreakMode = UILineBreakModeWordWrap;
    _lblBranchName.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(20)];
    _lblBranchName.text=name;
    [_lblBranchName sizeToFit];
    
    CGRect rect=_lblAddress.frame;
    rect.origin.y=_lblBranchName.frame.origin.y+_lblBranchName.frame.size.height+5;
    _lblAddress.frame=rect;
    _lblAddress.backgroundColor = [UIColor clearColor];
    _lblAddress.textColor = [UIColor whiteColor];
    _lblAddress.numberOfLines = 0;
    _lblAddress.lineBreakMode = UILineBreakModeWordWrap;
    _lblAddress.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
    _lblAddress.text= address;
    [_lblAddress sizeToFit];
    
    rect=_backgroundLocation.frame;
    rect.size.height=_lblBranchName.frame.size.height+5+ _lblAddress.frame.size.height+15;
    _backgroundLocation.frame=rect;
}


- (void)setTextForSkin:(UIImage *)bottomImage fontText:(int)fontText rectView:(CGRect)rectView text:(NSString *)text {
    int textSize=fontText*(bottomImage.size.width/320);
    
    UIFont *font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(textSize)];
    CGRect rect = CGRectMake(rectView.origin.x*bottomImage.size.width/320, rectView.origin.y*bottomImage.size.width/320, rectView.size.width*bottomImage.size.width/320, rectView.size.height*bottomImage.size.width/320);
    
    [ text drawInRect : CGRectIntegral(rect)                      // render the text
             withFont : font
        lineBreakMode : UILineBreakModeWordWrap  // clip overflow from end of last line
            alignment : UITextAlignmentCenter ];
}


- (UIImage*)mergeSkinWithImage:(UIImage *)bottomImage{
    UIGraphicsBeginImageContext(bottomImage.size);
    [bottomImage drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height)];
    [[UIColor whiteColor] set];
    UILabel* lbl=_lblBranchName;
    
    NSString* text=lbl.text;
    CGRect rectView=lbl.frame;
    
    int fontText=20;
    
    [self setTextForSkin:bottomImage fontText:fontText rectView:rectView text:text];
    
    text=_lblAddress.text;
    rectView=_lblAddress.frame;
    fontText=13;
    [self setTextForSkin:bottomImage fontText:fontText rectView:rectView text:text];
    
    UIImage* imageLocation=[UIImage imageNamed:@"img_skin_common_location"];
    rectView=_imagLocationIcon.frame;
    CGRect rect = CGRectMake(rectView.origin.x*bottomImage.size.width/320, rectView.origin.y*bottomImage.size.width/320, rectView.size.width*bottomImage.size.width/320, rectView.size.height*bottomImage.size.width/320);
    [imageLocation drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    
    [[UIColor colorWithWhite:1.0 alpha:.2] set];
    
    rectView=_backgroundLocation.frame;
    rect = CGRectMake(rectView.origin.x*bottomImage.size.width/320, rectView.origin.y*bottomImage.size.width/320, rectView.size.width*bottomImage.size.width/320, rectView.size.height*bottomImage.size.width/320);
    
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
