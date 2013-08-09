//
//  PageOneView.m
//  Anuong
//
//  Created by Hoang The Hung on 7/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PageFourView.h"
#import "TVBranch.h"
//#import "NSDate+Helper.h"
#import "NSDate-Utilities.h"
#import "UILabel+DynamicHeight.h"
#import <QuartzCore/QuartzCore.h>

static int radius=3;

@implementation PageFourView

- (void)settingView
{
    _lblBranchName.backgroundColor = [UIColor clearColor];
    _lblBranchName.textColor = [UIColor blackColor];
    _lblBranchName.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(20)];
    
    _lblAddress.backgroundColor = [UIColor clearColor];
    _lblAddress.textColor = [UIColor whiteColor];
    _lblAddress.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
    
    [_bgBranchView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:.8]];
    [_bgBranchAddress setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:.8]];
}


-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setName:(NSString*)name andAddress:(NSString*)address{
    
    _lblBranchName.text=name;
    [_lblBranchName resizeToStretchWidth:290];
    CGRect rect=_lblBranchName.frame;
    CGFloat lineHeight = _lblBranchName.font.leading;
    int linesInLabel = rect.size.height/lineHeight+.5;
    if (linesInLabel==1) {
        [_lblBranchName resizeWidthToStretchToCenter];
    }
    rect=_lblBranchName.frame;
    rect.origin.x += 8;
    [_lblBranchName setFrame:rect];
    
    rect=_imagLocationIcon.frame;
    rect.origin.x=_lblBranchName.frame.origin.x-_imagLocationIcon.frame.size.width-3;
    _imagLocationIcon.frame=rect;
    
    rect=_lblAddress.frame;
    rect.origin.y=_lblBranchName.frame.origin.y+_lblBranchName.frame.size.height+8;
    _lblAddress.frame=rect;
    
    _lblAddress.text= address;
    [_lblAddress resizeToStretchWidth:290];

    
        lineHeight = _lblAddress.font.leading;
        linesInLabel = rect.size.height/lineHeight+.5;
        if (linesInLabel==1) {
            [_lblAddress resizeWidthToStretchToCenter];
        }
    
    
    float padHeight=_lblAddress.frame.origin.y;
    rect= _lblAddress.frame;
    rect.origin.y = 320-10-rect.size.height;
    _lblAddress.frame=rect;
    padHeight=rect.origin.y-padHeight;
    
    rect= _imagLocationIcon.frame;
    rect.origin.y+=padHeight;
    _imagLocationIcon.frame=rect;
    
    rect= _lblBranchName.frame;
    rect.origin.y+=padHeight;
    _lblBranchName.frame=rect;
    
    rect= _imagImHereIcon.frame;
    rect.origin.y+=padHeight;
    _imagImHereIcon.frame=rect;
    
    rect=_lblBranchName.frame;
    rect.origin.x-=20+8;
    rect.origin.y-=5;
    rect.size.width+=40;
    rect.size.height+=10;
    _bgBranchView.frame=rect;
    
    rect=_lblAddress.frame;
    rect.origin.x-=3;
    rect.origin.y-=3;
    rect.size.width+=6;
    rect.size.height+=6;
    _bgBranchAddress.frame=rect;
    
    
    
}


- (void)setTextForSkin:(CGSize )size fontText:(int)fontText rectView:(CGRect)rectView text:(NSString *)text {
    int textSize=fontText*(size.width/320);
    
    UIFont *font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(textSize)];
    CGRect rect = CGRectMake(rectView.origin.x*size.width/320, rectView.origin.y*size.width/320, rectView.size.width*size.width/320, rectView.size.height*size.width/320);
    
    [ text drawInRect : CGRectIntegral(rect)                      // render the text
             withFont : font
        lineBreakMode : UILineBreakModeWordWrap  // clip overflow from end of last line
            alignment : UITextAlignmentCenter ];
}


- (UIImage*)mergeSkinWithImage:(UIImage *)bottomImage{
    float ratioImage=bottomImage.size.width/320;
    UIGraphicsBeginImageContext(bottomImage.size);
    [bottomImage drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height)];
    [[UIColor whiteColor] set];
    UILabel* lbl=_lblBranchName;
    
    NSString* text=lbl.text;
    CGRect rectView=[_bgBranchView convertRect:lbl.frame toView:_viewSkin];
    int fontText=20;
    [self setTextForSkin:bottomImage.size fontText:fontText rectView:rectView text:text];
    
    text=_lblAddress.text;
    rectView=[_bgBranchView convertRect:_lblAddress.frame toView:_viewSkin];;
    fontText=13;
    [self setTextForSkin:bottomImage.size fontText:fontText rectView:rectView text:text];
    
    UIImage* imageLocation=[UIImage imageNamed:@"skin_thu_tuc_truoc_khi_an_icon"];
    
    rectView=[_bgBranchView convertRect:_imagLocationIcon.frame toView:_viewSkin];
    CGRect rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imageLocation drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage* imgImHere=[UIImage imageNamed:@"skin_thu_tuc_truoc_khi_an_text"];
    rectView=_imagImHereIcon.frame ;
    rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imgImHere drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    [[UIColor colorWithWhite:1.0 alpha:0.3] set];
    rectView=_bgBranchView.frame;
    rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius*ratioImage] fill];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



@end
