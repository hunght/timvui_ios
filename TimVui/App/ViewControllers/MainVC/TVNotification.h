//
//  TVNotification.h
//  TimVui
//
//  Created by Hoang The Hung on 6/18/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVNotification : UIView<UIScrollViewDelegate>
@property (copy) void (^btnCommentCallback)();
@property (copy) void (^btnCameraCallback)();
@property(strong, nonatomic)UIButton* btnOpen;
@property (assign, nonatomic)int height;
@property (assign, nonatomic) BOOL isHiddenYES;
@property (assign, nonatomic) BOOL isAnimating;
-(id)initWithView:(UIView*)_view withTitle:(NSString*)strTitle goWithCamera:(void (^)())cameraCall
      withComment:(void (^)())commentCall;
-(void)openButtonClicked:(id)sender;
-(void)closeButtonClicked:(id)sender;
@end
