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
    _lblBranchName.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(25)];
    _lblBranchName.textColor=kOrangeTextColor;
    _lblBranchName.textAlignment = UITextAlignmentLeft;
    _lblAddress.backgroundColor = [UIColor clearColor];
    _lblAddress.textColor = [UIColor whiteColor];
    _lblAddress.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
    _lblAddress.textAlignment = UITextAlignmentLeft;
}

-(void)setName:(NSString*)name andAddress:(NSString*)address{
    name=[name uppercaseString];
    address=[address uppercaseString];
    _lblBranchName.text=name;
    [_lblBranchName resizeToStretch];
    
    CGRect rect=_lblAddress.frame;
    rect.origin.y=_lblBranchName.frame.origin.y+_lblBranchName.frame.size.height -3;
    _lblAddress.frame=rect;
    _lblAddress.text= address;
    [_lblAddress resizeToStretch];
    
    rect=_backgroundLocation.frame;
    rect.size.height=_lblBranchName.frame.size.height+5+ _lblAddress.frame.size.height+15;
    _backgroundLocation.frame=rect;
    rect=_backgroundLocation.frame;
    float padHeight=_backgroundLocation.frame.origin.y;
    rect.size.height=_lblBranchName.frame.size.height+5+ _lblAddress.frame.size.height;
    rect.origin.y = 320 - rect.size.height;
    padHeight=rect.origin.y-padHeight;
    _backgroundLocation.frame=rect;
    
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
    [[UIColor colorWithWhite:1.0 alpha:.2] set];
    rectView=_backgroundLocation.frame;
    CGRect  rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
    [self setTextForSkin:_lblBranchName fontText:25 sizeBottomImage:bottomImage.size];
    
    
    [self setTextForSkin:_lblAddress fontText:13 sizeBottomImage:bottomImage.size];
    
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
