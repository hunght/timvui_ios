//
//  PageOneView.m
//  Anuong
//
//  Created by Hoang The Hung on 7/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PageThreeView.h"
#import "TVBranch.h"
//#import "NSDate+Helper.h"
#import "NSDate-Utilities.h"
#import "UILabel+DynamicHeight.h"
#import <QuartzCore/QuartzCore.h>

static int radius=3;

@implementation PageThreeView

- (void)settingView
{
    _lblBranchName.backgroundColor = [UIColor clearColor];
    _lblBranchName.textColor = [UIColor whiteColor];
    _lblBranchName.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(20)];
    _lblAddress.backgroundColor = [UIColor clearColor];
    _lblAddress.textColor = [UIColor whiteColor];
    _lblAddress.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
    CALayer*l=    _bgBranchView.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    [_imagTriangleIcon setAlpha:.3];
}


-(void)layoutSubviews{
    [super layoutSubviews];

}

-(void)setName:(NSString*)name andAddress:(NSString*)address{
    name=[name uppercaseString];
    address=[address uppercaseString];
    _lblBranchName.text=name;
    [_lblBranchName resizeToStretchWidth:290];
    CGRect rect=_lblBranchName.frame;
    CGFloat lineHeight = _lblBranchName.font.leading;
    int linesInLabel = rect.size.height/lineHeight+.5;
    if (linesInLabel==1) {
        [_lblBranchName resizeWidthToStretchToCenter];
    }
    
    rect=_imagLocationIcon.frame;
    rect.origin.x=_lblBranchName.frame.origin.x-_imagLocationIcon.frame.size.width+ 5;
    _imagLocationIcon.frame=rect;
    
    rect=_lblAddress.frame;
    rect.origin.y=_lblBranchName.frame.origin.y+_lblBranchName.frame.size.height-2;
    _lblAddress.frame=rect;
    
    _lblAddress.text= address;
    [_lblAddress resizeToStretchWidth:290];
    
    if (linesInLabel==1) {
        CGFloat lineHeight = _lblAddress.font.leading;
        rect= _lblAddress.frame;
        int linesInLabel = rect.size.height/lineHeight+.5;
        
        if (linesInLabel==1) {
            CGPoint point=_lblAddress.center;
            [_lblAddress resizeWidthToStretchToCenter];
            _lblAddress.center=point;
            
            float maxWidth=(_lblAddress.frame.origin.x<_imagLocationIcon.frame.origin.x)?_lblAddress.frame.origin.x:_imagLocationIcon.frame.origin.x;
            CGRect rect=_bgBranchView.frame;
            point=_bgBranchView.center;
            
            rect.size.width=320-maxWidth*2+ 6;
            _bgBranchView.frame=rect;
            _bgBranchView.center=point;
        }
    }
    
    rect=_bgBranchView.frame;
    float padHeight=_bgBranchView.frame.origin.y;
    rect.size.height=_lblBranchName.frame.size.height+5+ _lblAddress.frame.size.height;
    rect.origin.y = _imagTriangleIcon.frame.origin.y-rect.size.height;
    padHeight=rect.origin.y-padHeight;
    _bgBranchView.frame=rect;
    
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

- (UIImage*)mergeSkinWithImage:(UIImage *)bottomImage{
    float ratioImage=bottomImage.size.width/320;
    
    UIGraphicsBeginImageContext(bottomImage.size);
    [bottomImage drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height)];
    
    CGRect rectView;
    
    [[UIColor colorWithWhite:1.0 alpha:0.3] set];
    rectView=_bgBranchView.frame;
    CGRect rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius*ratioImage] fill];
    [self setTextForSkin:_lblBranchName fontText:20 sizeBottomImage:bottomImage.size];
    
    [self setTextForSkin:_lblAddress fontText:13 sizeBottomImage:bottomImage.size];

    UIImage* imageLocation=[UIImage imageNamed:@"skin_toi_dang_o_day_icon"];
    
    rectView=_imagLocationIcon.frame;
     rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imageLocation drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage* imgImHere=[UIImage imageNamed:@"skin_toi_dang_o_day"];
    rectView=_imagImHereIcon.frame ;
    rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imgImHere drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage* imgTriAngle=[UIImage imageNamed:@"skin_toi_dang_o_day_tam_giac"];
    rectView=_imagTriangleIcon.frame;
    rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imgTriAngle drawInRect:rect blendMode:kCGBlendModeNormal alpha:0.3];
    
   
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



@end
