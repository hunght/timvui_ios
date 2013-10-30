//
//  TVNotification.m
//  TimVui
//
//  Created by Hoang The Hung on 6/18/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVNotification.h"
#import "MacroApp.h"
#import "TTTAttributedLabel.h"
@implementation TVNotification
-(id)initWithView:(UIView*)_view withTitle:(NSString*)strTitle goWithCamera:(void (^)())cameraCall
      withComment:(void (^)())commentCall{
    self=[super initWithFrame:CGRectZero];
    if (self) {
        
        // Drawing code
        int height=20;
        if (strTitle) {
            
            
            UILabel *lblYouAre = [[UILabel alloc] initWithFrame:CGRectMake(17, height, 120, 23)];
            lblYouAre.backgroundColor = [UIColor clearColor];
            lblYouAre.textColor = kGrayTextColor;
            lblYouAre.font = [UIFont fontWithName:@"ArialMT" size:(10)];
            lblYouAre.text=@"Có vẻ bạn đang ở";
            [self addSubview:lblYouAre];
            
            UILabel *lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(139, height, 180, 23)];
            lblDetailRow.backgroundColor = [UIColor clearColor];
            lblDetailRow.textColor = kCyanGreenColor;
            lblDetailRow.font = [UIFont fontWithName:@"Arial-BoldMT" size:(10)];
            lblDetailRow.text =strTitle;
            [self addSubview:lblDetailRow];
            
            height=lblDetailRow.frame.origin.y+lblDetailRow.frame.size.height;
            
            UILabel *lblPlease = [[UILabel alloc] initWithFrame:CGRectMake(17, height, 270, 23)];
            lblPlease.backgroundColor = [UIColor clearColor];
            lblPlease.textColor = kGrayTextColor;
            lblPlease.font = [UIFont fontWithName:@"ArialMT" size:(10)];
            lblPlease.text=@"Hãy Chụp ảnh hoặc Viết đánh giá để chia sẻ với bạn bè";
            [self addSubview:lblPlease];

            height=lblPlease.frame.origin.y+lblPlease.frame.size.height;
            UIView* bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, height-20)];
            [bgView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.95]];
            [self insertSubview:bgView belowSubview:lblYouAre];
            
            UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, height, 320, 1.0)];
            grayLine.backgroundColor = [UIColor blackColor];
            [self addSubview:grayLine];
        }
        
        UIButton* cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height, 160, 43)];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_main_camera_on"] forState:UIControlStateNormal];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_main_camera_off"] forState:UIControlStateHighlighted];
        [cameraButton setTitle:@"             CHỤP ẢNH" forState:UIControlStateNormal];
        [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cameraButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
        [cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(160, height, 1.0, 43)];
        grayLine.backgroundColor = [UIColor blackColor];
        
        
        UIButton* commentButton = [[UIButton alloc] initWithFrame:CGRectMake(161, height   , 160, 43)];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"img_main_comment_on"] forState:UIControlStateNormal];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"img_main_comment_off"] forState:UIControlStateHighlighted];
        [commentButton setTitle:@"             ĐÁNH GIÁ" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
        
        [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (strTitle) {
            UIButton* btnClose = [[UIButton alloc] initWithFrame:CGRectMake(320-34-3, 0, 34, 34)];
            [btnClose setBackgroundImage:[UIImage imageNamed:@"img_main_notification_close"] forState:UIControlStateNormal];
            [btnClose addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnClose];
        }else{
            _btnOpen = [[UIButton alloc] initWithFrame:CGRectZero];
            [_btnOpen setBackgroundImage:[UIImage imageNamed:@"img_main_open_button"] forState:UIControlStateNormal];
            [_btnOpen addTarget:self action:@selector(openButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_view addSubview:_btnOpen];
            
        }
        _isHiddenYES=YES;
        [self addSubview:cameraButton];
        [self addSubview:commentButton];
        [self addSubview:grayLine];
        
        _height=commentButton.frame.size.height+commentButton.frame.origin.y;
        CGRect _frame= CGRectMake(0, _view.frame.size.height, 320,_height );
        self.frame=_frame;
//        [self setBackgroundColor:[UIColor colorWithRed:(25/255.0f) green:(25/255.0f) blue:(16/255.0f) alpha:.90f]];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [_view addSubview:self];
        
        //Add open button
        

        
        self.btnCameraCallback =cameraCall;
        self.btnCommentCallback=commentCall;
    }
    self.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin ;
//    _btnOpen.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin;
    if (([[UIScreen mainScreen] bounds].size.height == 568)) {
        _btnOpen.frame= CGRectMake(320-32-18,568 -32-5- 44- 22, 34, 34);
    }else{
        _btnOpen.frame= CGRectMake(320-32-18, _view.frame.size.height-32-5, 34, 34);
    }
    return self;
}

-(id)initWithView:(UIView*)_view withTitle:(NSString*)strTitle withDistance:(NSString*)distance goWithClickView:(void (^)())cameraCall{
    self=[super initWithFrame:CGRectZero];
    if (self) {
        
        // Drawing code
        int height=20;
        if (strTitle) {
            NSString* text;
            if (distance) {
                text=[NSString stringWithFormat:@"%@ (cách %@) vừa tạo Coupon giảm giá dành cho thành viên ĂnUống.net",strTitle,distance];
            }else{
                text=[NSString stringWithFormat:@"%@ vừa tạo Coupon giảm giá dành cho thành viên ĂnUống.net",strTitle];
            }
            TTTAttributedLabel* _lblContent = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(17, height+5, 270, 46)];
            _lblContent.font = [UIFont fontWithName:@"ArialMT" size:(13)];
            _lblContent.textColor = [UIColor whiteColor];
            _lblContent.lineBreakMode = UILineBreakModeWordWrap;
            _lblContent.numberOfLines = 2;
            _lblContent.backgroundColor=[UIColor clearColor];
            [_lblContent setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
                UIFont *boldSystemFont = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];;
                NSRange whiteRange = [text rangeOfString:strTitle];
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
                
                if (whiteRange.location != NSNotFound) {
                    // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)kCyanGreenColor.CGColor range:whiteRange];
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:whiteRange];
                    CFRelease(font);
                }
                
                return mutableAttributedString;
            }];
            

            [self addSubview:_lblContent];

            height=_lblContent.frame.origin.y+_lblContent.frame.size.height;
            UIView* bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, height+23)];
            [bgView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.95]];
            [self insertSubview:bgView belowSubview:_lblContent];
        }
        
        UIButton* cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(-25, height-5, 160, 23)];
        
        [cameraButton setTitle:@"Bấm để xem >" forState:UIControlStateNormal];
        [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cameraButton.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:(11)];
        [cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(160, height, 1.0, 43)];
        grayLine.backgroundColor = [UIColor blackColor];

        if (strTitle) {
            UIButton* btnClose = [[UIButton alloc] initWithFrame:CGRectMake(320-34-3, 0, 34, 34)];
            [btnClose setBackgroundImage:[UIImage imageNamed:@"img_main_notification_close"] forState:UIControlStateNormal];
            [btnClose addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnClose];
        }else{
            _btnOpen = [[UIButton alloc] initWithFrame:CGRectZero];
            [_btnOpen setBackgroundImage:[UIImage imageNamed:@"img_main_open_button"] forState:UIControlStateNormal];
            [_btnOpen addTarget:self action:@selector(openButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_view addSubview:_btnOpen];
            
        }
        _isHiddenYES=YES;
        [self addSubview:cameraButton];
        [self addSubview:grayLine];
        
        _height=cameraButton.frame.size.height+cameraButton.frame.origin.y;
        CGRect _frame= CGRectMake(0, _view.frame.size.height, 320,_height );
        self.frame=_frame;
        //        [self setBackgroundColor:[UIColor colorWithRed:(25/255.0f) green:(25/255.0f) blue:(16/255.0f) alpha:.90f]];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [_view addSubview:self];
        
        //Add open button
        self.btnCameraCallback =cameraCall;
    }
    self.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin ;
    _btnOpen.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin;
    return self;
}

-(void)openButtonClicked:(id)sender{
    if (!_isHiddenYES||_isAnimating)
        return;
    if (sender) {
        CGAffineTransform transform = CGAffineTransformMakeTranslation(50+5,0);
        transform = CGAffineTransformRotate(transform, 360);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            _btnOpen.transform = transform;
            self.isAnimating=YES;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.transform= CGAffineTransformMakeTranslation(0,-_height);
            } completion:^(BOOL finished){
                self.isAnimating=NO;
                self.isHiddenYES=NO;
            }];
        }];
    }else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.transform= CGAffineTransformMakeTranslation(0,-_height);
        } completion:^(BOOL finished){
            self.isAnimating=NO;
            self.isHiddenYES=NO;
        }];
    }

}

-(void)closeButtonClicked:(id)sender{

    if (_isHiddenYES||_isAnimating)
        return;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform= CGAffineTransformIdentity;
        self.isAnimating=YES;
    } completion:^(BOOL finished){
        if (sender) {
            [self removeFromSuperview];
            return;
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _btnOpen.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            self.isAnimating=NO;
            self.isHiddenYES=YES;
        }];
    }];
}

-(void)cameraButtonClicked:(id)sender{
    if (self.btnCameraCallback)
    {
        self.btnCameraCallback();
    }
}

-(void)commentButtonClicked:(id)sender{
    if (self.btnCommentCallback)
    {
        self.btnCommentCallback();
    }
}

@end
