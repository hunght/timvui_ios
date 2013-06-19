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
        
        
        UIButton* cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(7, lblDetailRow.frame.size.height+ 3, 101, 38)];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_camera"] forState:UIControlStateNormal];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_camera_on"] forState:UIControlStateHighlighted];
        [cameraButton setTitle:@"             CHỤP ẢNH" forState:UIControlStateNormal];
        [cameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cameraButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(10)];
        [cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* commentButton = [[UIButton alloc] initWithFrame:CGRectMake(7+101+5, lblDetailRow.frame.size.height+ 3, 101, 38)];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment"] forState:UIControlStateNormal];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment_on"] forState:UIControlStateHighlighted];
        [commentButton setTitle:@"             BÌNH LUẬN" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(10)];
        
        [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cameraButton];
        [self addSubview:commentButton];
        int height=commentButton.frame.size.height+commentButton.frame.origin.y+5;
        CGRect _frame= CGRectMake(0, _view.frame.size.height-height-40, 320,height );
        self.frame=_frame;
        [self setBackgroundColor:[UIColor colorWithRed:(101.0f/255.0f) green:(111.0f/255.0f) blue:(85.0f/255.0f) alpha:1.0f]];
        self.btnCameraCallback =cameraCall;
        self.btnCommentCallback=commentCall;
        [_view addSubview:self];
    }
    return self;
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
