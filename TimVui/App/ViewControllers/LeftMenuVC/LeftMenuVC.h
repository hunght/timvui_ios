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
@interface LeftMenuVC : UITableViewController <VPPDropDownDelegate, UIActionSheetDelegate, LoginVCDelegate,FBLoginViewDelegate> {
@private
    NSArray *_headers;
    VPPDropDown *_dropDownCustom;
    
    NSIndexPath *_globalIndexPath;
}

@end
