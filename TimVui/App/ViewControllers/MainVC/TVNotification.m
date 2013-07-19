//
//  TVNotification.m
//  TimVui
//
//  Created by Hoang The Hung on 6/18/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVNotification.h"

@implementation TVNotification
-(id)initWithView:(UIView*)_view withTitle:(NSString*)strTitle goWithCamera:(void (^)())cameraCall
      withComment:(void (^)())commentCall{
    self=[super initWithFrame:CGRectZero];
    if (self) {
        
        // Drawing code
        int height=20;
        if (strTitle) {
            UILabel *lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(3, height, 130, 23)];
            lblDetailRow.backgroundColor = [UIColor clearColor];
            lblDetailRow.textColor = [UIColor blackColor];
            lblDetailRow.numberOfLines = 0;
            lblDetailRow.lineBreakMode = UILineBreakModeWordWrap;
            lblDetailRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
            lblDetailRow.text =strTitle;
            [lblDetailRow sizeToFit];
            [self addSubview:lblDetailRow];
            UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, lblDetailRow.frame.size.height+ 1, 320, 1.0f)];
            grayLine.backgroundColor = [UIColor colorWithRed:(243/255.0f) green:(243/255.0f) blue:(243/255.0f) alpha:1.0f];
            height=grayLine.frame.origin.y+grayLine.frame.size.height;
            [self addSubview:grayLine];
        }
        
        UIButton* cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height, 160, 43)];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_main_camera_on"] forState:UIControlStateNormal];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_main_camera_off"] forState:UIControlStateHighlighted];
        [cameraButton setTitle:@"             CHỤP ẢNH" forState:UIControlStateNormal];
        [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cameraButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
        [cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* commentButton = [[UIButton alloc] initWithFrame:CGRectMake(161, height   , 160, 43)];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"img_main_comment_on"] forState:UIControlStateNormal];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"img_main_comment_off"] forState:UIControlStateHighlighted];
        [commentButton setTitle:@"             BÌNH LUẬN" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
        
        [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* btnClose = [[UIButton alloc] initWithFrame:CGRectMake(320-34-3, 0, 34, 34)];
        [btnClose setBackgroundImage:[UIImage imageNamed:@"img_main_notification_close"] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cameraButton];
        [self addSubview:commentButton];
        [self addSubview:btnClose];
        
        _height=commentButton.frame.size.height+commentButton.frame.origin.y+4+40;
        CGRect _frame= CGRectMake(0, _view.frame.size.height, 320,_height );
        self.frame=_frame;
//        [self setBackgroundColor:[UIColor colorWithRed:(25/255.0f) green:(25/255.0f) blue:(16/255.0f) alpha:.90f]];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [_view addSubview:self];
        
        //Add open button
        
        _btnOpen = [[UIButton alloc] initWithFrame:CGRectMake(320-32-18, _view.frame.size.height-32-44-5, 34, 34)];
        [_btnOpen setBackgroundImage:[UIImage imageNamed:@"img_main_open_button"] forState:UIControlStateNormal];
        [_btnOpen addTarget:self action:@selector(openButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:_btnOpen];
        _isHiddenYES=YES;
        
        self.btnCameraCallback =cameraCall;
        self.btnCommentCallback=commentCall;
    }
    return self;
}

-(void)openButtonClicked:(id)sender{
    if (!_isHiddenYES||_isAnimating)
        return;
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
}

-(void)closeButtonClicked:(id)sender{
    if (_isHiddenYES||_isAnimating)
        return;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform= CGAffineTransformIdentity;
        self.isAnimating=YES;
    } completion:^(BOOL finished){
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
