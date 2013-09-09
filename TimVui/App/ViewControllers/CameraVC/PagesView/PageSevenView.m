//
//  PageOneView.m
//  Anuong
//
//  Created by Hoang The Hung on 7/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PageSevenView.h"
#import "TVBranch.h"
//#import "NSDate+Helper.h"
#import "NSDate-Utilities.h"
#import "UILabel+DynamicHeight.h"
@implementation PageSevenView

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
    name=[name uppercaseString];
    address=[address uppercaseString];
    _lblBranchName.text=name;
    [_lblBranchName resizeToStretch];

    _lblAddress.text= address;
    [_lblAddress resizeToStretch];

   CGRect    rect=_lblBranchName.frame;
    float padHeight=_lblBranchName.frame.origin.y;
    rect.origin.y = 320 - rect.size.height-10;
    padHeight=rect.origin.y-padHeight;
    _lblBranchName.frame=rect;
    
    rect= _viewVitoryFinger.frame;
    rect.origin.y+=padHeight;
    _viewVitoryFinger.frame=rect;
    
}




- (UIImage*)mergeSkinWithImage:(UIImage *)bottomImage{
    float ratioImage=bottomImage.size.width/320;;
    UIGraphicsBeginImageContext(bottomImage.size);
    [bottomImage drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height)];
    CGRect rectView;
    [self setTextForSkin:_lblBranchName fontText:20 sizeBottomImage:bottomImage.size];
    
    
    [self setTextForSkin:_lblAddress fontText:13 sizeBottomImage:bottomImage.size];
    
    UIImage* imageLocation=[UIImage imageNamed:@"skin_pose_phat_icon"];
    rectView=_imagLocationIcon.frame;
    CGRect rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imageLocation drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage* imgVictoryFinger=[UIImage imageNamed:@"skin_tu_suong_text"];
    rectView=_viewVitoryFinger.frame;
    rect = CGRectMake(rectView.origin.x*ratioImage, rectView.origin.y*ratioImage, rectView.size.width*ratioImage, rectView.size.height*ratioImage);
    [imgVictoryFinger drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
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
