//
//  GlobalDataUser.h
//  TimVui
//
//  Created by Hoang The Hung on 4/17/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "GHUser.h"

@interface GlobalDataUser : NSObject<CLLocationManagerDelegate>

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CLLocationCoordinate2D userLocation;

@property (assign, nonatomic) NSNumber *userID;
@property (retain, nonatomic) GHUser *user;
@property (retain, nonatomic) NSString *facebookID;
@property (retain, nonatomic) NSDictionary *dicCity;
@property (assign, nonatomic) BOOL isLogin;
-(NSDictionary *)dicCity;
+ (GlobalDataUser *)sharedAccountClient;
-(void)setGlocalDataUser:(NSDictionary *)attributes;
-(CLLocationDistance)distanceFromAddress:(CLLocationCoordinate2D)fromAdd;
-(void)userLogout;
@end
