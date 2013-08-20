//
//  PageOneView.m
//  Anuong
//
//  Created by Hoang The Hung on 7/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PageElevenView.h"
#import "TVBranch.h"
#import "NSDate-Utilities.h"
#import "UILabel+DynamicHeight.h"
@implementation PageElevenView

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
    
    _lblTime.font = [UIFont fontWithName:@"VNF Prime" size:(10)];
    NSDate* date=[NSDate date];
    int weekday=[date weekday];
    
    _lblTime.text=(weekday!=8)?[NSString stringWithFormat:@"%@ THỨ %d",[date stringWithFormat:@"HH:mm"],weekday]:[NSString stringWithFormat:@"%@ CHỦ NHẬT",[date stringWithFormat:@"HH:mm"]];
}

-(void)setName:(NSString*)name andAddress:(NSString*)address{
    
    
    _lblBranchName.text=name;
    [_lblBranchName resizeToStretch];
    CGRect rect=_lblLineTop.frame;
    rect.origin.y=_lblBranchName.frame.origin.y+_lblBranchName.frame.size.height;
    _lblLineTop.frame=rect;
    
    rect=_lblAddress.frame;
    rect.origin.y=_lblLineTop.frame.origin.y+_lblLineTop.frame.size.height;
    _lblAddress.frame=rect;
    _lblAddress.text= address;
    [_lblAddress resizeToStretch];
    
    rect=_lblLineBottom.frame;
    rect.origin.y=_lblAddress.frame.origin.y+_lblAddress.frame.size.height-5;
    _lblLineBottom.frame=rect;

    rect=_lblTime.frame;
    rect.origin.y=_lblLineBottom.frame.origin.y+_lblLineBottom.frame.size.height+2;
    _lblTime.frame=rect;

    rect=_imgClockIcon.frame;
    rect.origin.y=_lblLineBottom.frame.origin.y+_lblLineBottom.frame.size.height+5;
    _imgClockIcon.frame=rect;

}



- (UIImage*)mergeSkinWithImage:(UIImage *)bottomImage{
    float ratioImage=bottomImage.size.width/320;
    UIGraphicsBeginImageContext(bottomImage.size);
    [bottomImage drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height)];
    CGRect rectView;
    [[UIColor colorWithWhite:1.0 alpha:.2] set];
    rectView=_backgroundLocation.frame;
    CGRect rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
    [self setTextForSkin:_lblBranchName fontText:20 sizeBottomImage:bottomImage.size];
    
    
    [self setTextForSkin:_lblAddress fontText:13 sizeBottomImage:bottomImage.size];
    
    [self setTextForSkin:_lblLineTop fontText:_lblLineTop.font.leading sizeBottomImage:bottomImage.size];
    [self setTextForSkin:_lblLineBottom fontText:_lblLineBottom.font.leading sizeBottomImage:bottomImage.size];
    [self setTextForSkin:_lblTime fontText:_lblTime.font.leading sizeBottomImage:bottomImage.size];

    UIImage* imgLike=[UIImage imageNamed:@"skin_Like_icon"];
    rectView=_imgLike.frame;
     rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imgLike drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage* imgClockIcon=[UIImage imageNamed:@"skin_clock_icon"];
    rectView=_imgClockIcon.frame;
    rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imgClockIcon drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    
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
