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
#import <FacebookSDK/FacebookSDK.h>
@interface LeftMenuVC : UITableViewController <VPPDropDownDelegate, UIActionSheetDelegate,FBLoginViewDelegate> {
@private
    NSArray *_headers;
    VPPDropDown *_dropDownCustom;
    BOOL _lastStatusLogin;
    NSIndexPath *_globalIndexPath;
}
- (void)openViewController:(UIViewController *)viewController;
@end
