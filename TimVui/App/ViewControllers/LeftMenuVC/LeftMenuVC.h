//
//  DropDownExample.h
//  VPPLibraries
//
//  Created by Víctor on 13/12/11.
//  Copyright (c) 2011 Víctor Pena Placer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
@class TVBranches,TVBranch;
@interface LeftMenuVC : UITableViewController <UIActionSheetDelegate> {
@private
    NSArray *_headers;
    NSIndexPath* lastIndexPath;
    BOOL _lastStatusLogin;
    BOOL isRotatedYES;
    BOOL isNotTheFirstTimeOpenHomeYES;
}

- (void)openViewController:(UIViewController *)viewController;
- (void)commentButtonClickedWithNav:(UINavigationController*)nav andWithBranches:(TVBranches*)branches;
- (void)commentButtonClickedWithNav:(UINavigationController*)nav andWithBranch:(TVBranch*)branch;
- (void)cameraButtonClickedWithNav:(UINavigationController*)nav andWithBranches:(TVBranches*)branches;
- (void)cameraButtonClickedWithNav:(UINavigationController*)nav andWithBranch:(TVBranch*)branch;

-(void)showLoginScreenWhenUserNotLogin:(UINavigationController*)nav;
@end
