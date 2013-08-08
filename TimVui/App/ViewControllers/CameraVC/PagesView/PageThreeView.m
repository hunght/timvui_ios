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
@implementation PageThreeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setName:(NSString*)name andAddress:(NSString*)address{
    _lblBranchName.backgroundColor = [UIColor clearColor];
    _lblBranchName.textColor = [UIColor whiteColor];
    _lblBranchName.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(20)];
    _lblBranchName.text=name;
    [_lblBranchName resizeToStretch];
    
    CGRect rect=_lblAddress.frame;
    rect.origin.y=_lblBranchName.frame.origin.y+_lblBranchName.frame.size.height+5;
    _lblAddress.frame=rect;
    _lblAddress.backgroundColor = [UIColor clearColor];
    _lblAddress.textColor = [UIColor whiteColor];
    _lblAddress.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
    _lblAddress.text= address;
    [_lblAddress resizeToStretch];
    
    rect=_bgBranchView.frame;
    rect.size.height=_lblBranchName.frame.size.height+5+ _lblAddress.frame.size.height+15;
    _bgBranchView.frame=rect;
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
    CGRect rectView=[lbl convertRect:lbl.frame toView:_viewSkin];
    int fontText=20;
    [self setTextForSkin:bottomImage.size fontText:fontText rectView:rectView text:text];
    
    text=_lblAddress.text;
    rectView=[_lblAddress convertRect:_lblAddress.frame toView:_viewSkin];;
    fontText=13;
    [self setTextForSkin:bottomImage.size fontText:fontText rectView:rectView text:text];
    
    UIImage* imageLocation=[UIImage imageNamed:@"skin_toi_dang_o_day_icon"];
    
    rectView=[_imagLocationIcon convertRect:_imagLocationIcon.frame toView:_viewSkin];
    CGRect rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imageLocation drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage* imgImHere=[UIImage imageNamed:@"skin_toi_dang_o_day"];
    rectView=[_imagImHereIcon convertRect:_imagImHereIcon.frame toView:_viewSkin];
    rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imgImHere drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage* imgTriAngle=[UIImage imageNamed:@"skin_toi_dang_o_day_tam_giac"];
    rectView=[_imagTriangleIcon convertRect:_imagTriangleIcon.frame toView:_viewSkin];
    rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imgTriAngle drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    [[UIColor colorWithWhite:1.0 alpha:0.3] set];
    rectView=_bgBranchView.frame;
    rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5*ratioImage] fill];
    
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
