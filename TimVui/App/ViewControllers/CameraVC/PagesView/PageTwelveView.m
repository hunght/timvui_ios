//
//  PageOneView.m
//  Anuong
//
//  Created by Hoang The Hung on 7/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PageTwelveView.h"
#import "TVBranch.h"

#import "NSDate-Utilities.h"
#import "UILabel+DynamicHeight.h"
@implementation PageTwelveView

- (void)settingView
{
    _lblBranchName.backgroundColor = [UIColor clearColor];
    _lblBranchName.textColor = [UIColor whiteColor];
    _lblBranchName.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(25)];
    _lblBranchName.textAlignment = UITextAlignmentLeft;
    _lblAddress.backgroundColor = [UIColor clearColor];
    _lblAddress.textColor = [UIColor whiteColor];
    _lblAddress.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
    _lblAddress.textAlignment = UITextAlignmentLeft;
    
    
    _lblTime.font = [UIFont fontWithName:@"VNF Prime" size:(10)];
    NSDate* date=[NSDate date];
    int weekday=[date weekday];
    
    _lblTime.text=(weekday!=8)?[NSString stringWithFormat:@"%@ THỨ %d | %@",[date stringWithFormat:@"HH:mm"],weekday,[date stringWithFormat:@"dd/MM/yyyy"]]:[NSString stringWithFormat:@"%@ CHỦ NHẬT | %@",[date stringWithFormat:@"HH:mm"],[date stringWithFormat:@"dd/MM/yyyy"]];
    
}

-(void)setName:(NSString*)name andAddress:(NSString*)address{
    name=[name uppercaseString];
    address=[address uppercaseString];
    _lblBranchName.text=name;
    [_lblBranchName resizeToStretch];
    
    CGRect rect=_lblAddress.frame;
    rect.origin.y=_lblBranchName.frame.origin.y+_lblBranchName.frame.size.height-3;
    _lblAddress.frame=rect;
    _lblAddress.text= address;
    [_lblAddress resizeToStretch];
    
    rect=_imagLocationIcon.frame;
    float padHeight=(_lblAddress.frame.origin.y+ 5 + _lblAddress.frame.size.height)-320;

    if (padHeight>0) {
        rect.origin.y -=padHeight;
        _imagLocationIcon.frame=rect;
        
        rect= _lblAddress.frame;
        rect.origin.y-=padHeight;
        _lblAddress.frame=rect;
        
        rect= _lblBranchName.frame;
        rect.origin.y-=padHeight;
        _lblBranchName.frame=rect;
    }
}


- (UIImage*)mergeSkinWithImage:(UIImage *)bottomImage{
    float ratioImage=bottomImage.size.width/320;
    UIGraphicsBeginImageContext(bottomImage.size);
    [bottomImage drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height)];
    CGRect rectView;
    [self setTextForSkin:_lblBranchName fontText:25 sizeBottomImage:bottomImage.size];
    
    
    [self setTextForSkin:_lblAddress fontText:13 sizeBottomImage:bottomImage.size];
    [self setTextForSkin:_lblTime fontText:_lblTime.font.leading sizeBottomImage:bottomImage.size];
    
    UIImage* imageLocation=[UIImage imageNamed:_strImageName];
    rectView=_imagLocationIcon.frame;
    CGRect rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imageLocation drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
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
