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
        UILabel *lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 130, 23)];
        lblDetailRow.backgroundColor = [UIColor clearColor];
        lblDetailRow.textColor = [UIColor blackColor];
        lblDetailRow.numberOfLines = 0;
        lblDetailRow.lineBreakMode = UILineBreakModeWordWrap;
        lblDetailRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblDetailRow.text =strTitle;
        [lblDetailRow sizeToFit];
        [self addSubview:lblDetailRow];
        
        UIButton* cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(7, lblDetailRow.frame.size.height+ 3, 150, 38)];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_camera"] forState:UIControlStateNormal];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_camera_on"] forState:UIControlStateHighlighted];
        [cameraButton setTitle:@"             CHỤP ẢNH" forState:UIControlStateNormal];
        [cameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cameraButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(10)];
        [cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* commentButton = [[UIButton alloc] initWithFrame:CGRectMake(7+150+5, lblDetailRow.frame.size.height+ 3, 150, 38)];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment"] forState:UIControlStateNormal];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment_on"] forState:UIControlStateHighlighted];
        [commentButton setTitle:@"             BÌNH LUẬN" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(10)];
        
        [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* btnClose = [[UIButton alloc] initWithFrame:CGRectMake(320-20-5, -10, 20, 20)];
        [btnClose setBackgroundImage:[UIImage imageNamed:@"img_main_open_button"] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cameraButton];
        [self addSubview:commentButton];
        [self addSubview:btnClose];
        
        _height=commentButton.frame.size.height+commentButton.frame.origin.y+5+40;
        CGRect _frame= CGRectMake(0, _view.frame.size.height, 320,_height );
        self.frame=_frame;
        [self setBackgroundColor:[UIColor colorWithRed:(101.0f/255.0f) green:(111.0f/255.0f) blue:(85.0f/255.0f) alpha:1.0f]];
        self.btnCameraCallback =cameraCall;
        self.btnCommentCallback=commentCall;
        [_view addSubview:self];
        
        //Add open button
        
        _btnOpen = [[UIButton alloc] initWithFrame:CGRectMake(320-32-18, _view.frame.size.height-32-44-5, 32, 32)];
        [_btnOpen setBackgroundImage:[UIImage imageNamed:@"img_main_open_button"] forState:UIControlStateNormal];
        [_btnOpen addTarget:self action:@selector(openButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:_btnOpen];
        _isHiddenYES=YES;
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
