//
//  DropDownExample.h
//  VPPLibraries
//
//  Created by Víctor on 13/12/11.
//  Copyright (c) 2011 Víctor Pena Placer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPPDropDown.h"
#import "VPPDropDownDelegate.h"
#import "LoginVC.h"
@class TVBranches,TVBranch;
@interface LeftMenuVC : UITableViewController <VPPDropDownDelegate, UIActionSheetDelegate> {
@private
    NSArray *_headers;
    VPPDropDown *_dropDownCustom;
    BOOL _lastStatusLogin;
    NSIndexPath *_globalIndexPath;
}

- (void)openViewController:(UIViewController *)viewController;
- (void)commentButtonClickedWithNav:(UINavigationController*)nav;
- (void)cameraButtonClickedWithNav:(UINavigationController*)nav andWithBranches:(TVBranches*)branches;
- (void)cameraButtonClickedWithNav:(UINavigationController*)nav andWithBranch:(TVBranch*)branch;
@end
