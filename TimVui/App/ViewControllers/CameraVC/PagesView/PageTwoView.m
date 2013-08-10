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
#import "UILabel+DynamicHeight.h"
@implementation PageTwoView

- (void)settingView
{
    _lblBranchName.backgroundColor = [UIColor clearColor];
    _lblBranchName.textColor = [UIColor whiteColor];
    _lblBranchName.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(20)];
    _lblBranchName.textAlignment = UITextAlignmentLeft;
    _lblAddress.backgroundColor = [UIColor clearColor];
    _lblAddress.textColor = [UIColor whiteColor];
    _lblAddress.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
    _lblAddress.textAlignment = UITextAlignmentLeft;
}

-(void)setName:(NSString*)name andAddress:(NSString*)address{
    _lblBranchName.text=name;
    [_lblBranchName resizeToStretch];
    
    CGRect rect=_lblAddress.frame;
    rect.origin.y=_lblBranchName.frame.origin.y+_lblBranchName.frame.size.height+5;
    _lblAddress.frame=rect;
    _lblAddress.text= address;
    [_lblAddress resizeToStretch];
    
    rect=_backgroundLocation.frame;
    rect.size.height=_lblBranchName.frame.size.height+5+ _lblAddress.frame.size.height+15;
    _backgroundLocation.frame=rect;
    rect=_backgroundLocation.frame;
    float padHeight=_backgroundLocation.frame.origin.y;
    rect.size.height=_lblBranchName.frame.size.height+5+ _lblAddress.frame.size.height+ 7;
    rect.origin.y = 320 - rect.size.height-10;
    padHeight=rect.origin.y-padHeight;
    _backgroundLocation.frame=rect;
    
    rect= _imagLocationIcon.frame;
    rect.origin.y+=padHeight;
    _imagLocationIcon.frame=rect;
    
    rect= _lblAddress.frame;
    rect.origin.y+=padHeight;
    _lblAddress.frame=rect;
    
    rect= _lblBranchName.frame;
    rect.origin.y+=padHeight;
    _lblBranchName.frame=rect;
    
}


- (void)setTextForSkin:(CGSize )size fontText:(int)fontText rectView:(CGRect)rectView text:(NSString *)text {
    int textSize=fontText*(size.width/320);
    
    UIFont *font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(textSize)];
    CGRect rect = CGRectMake(rectView.origin.x*size.width/320, rectView.origin.y*size.width/320, rectView.size.width*size.width/320, rectView.size.height*size.width/320);
    
    [ text drawInRect : CGRectIntegral(rect)                      // render the text
             withFont : font
        lineBreakMode : UILineBreakModeWordWrap  // clip overflow from end of last line
            alignment : NSTextAlignmentLeft ];
}


- (UIImage*)mergeSkinWithImage:(UIImage *)bottomImage{
    float ratioImage=bottomImage.size.width/320;
    UIGraphicsBeginImageContext(bottomImage.size);
    [bottomImage drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height)];
    [[UIColor whiteColor] set];
    UILabel* lbl=_lblBranchName;
    
    NSString* text=lbl.text;
    CGRect rectView=lbl.frame;
    int fontText=20;
    [self setTextForSkin:bottomImage.size fontText:fontText rectView:rectView text:text];
    
    text=_lblAddress.text;
    rectView=_lblAddress.frame;
    fontText=13;
    [self setTextForSkin:bottomImage.size fontText:fontText rectView:rectView text:text];
    
    UIImage* imageLocation=[UIImage imageNamed:@"img_skin_common_location"];
    rectView=_imagLocationIcon.frame;
    CGRect rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imageLocation drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    [[UIColor colorWithWhite:1.0 alpha:.2] set];
    rectView=_backgroundLocation.frame;
    rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    
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
