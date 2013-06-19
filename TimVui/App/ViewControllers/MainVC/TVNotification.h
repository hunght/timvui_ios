//
//  TVNotification.h
//  TimVui
//
//  Created by Hoang The Hung on 6/18/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVNotification : UIView
@property (copy) void (^btnCommentCallback)();
@property (copy) void (^btnCameraCallback)();
-(id)initWithView:(UIView*)_view withTitle:(NSString*)strTitle goWithCamera:(void (^)())cameraCall
      withComment:(void (^)())commentCall;

@end
