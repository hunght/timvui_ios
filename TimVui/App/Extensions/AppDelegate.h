//
//  AppDelegate.h
//  TimVui
//
//  Created by Hoang The Hung on 3/22/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MacroApp.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) UIViewController *leftController;
@property (nonatomic, strong)id<GAITracker> tracker;
// FBSample logic
// In this sample the app delegate maintains a property for the current
// active session, and the view controllers reference the session via
// this property, as well as play a role in keeping the session object
// up to date; a more complicated application may choose to introduce
// a simple singleton that owns the active FBSession object as well
// as access to the object by the rest of the application
@property (strong, nonatomic) FBSession *session;
@end
