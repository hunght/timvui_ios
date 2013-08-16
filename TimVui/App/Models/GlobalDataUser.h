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
@property (assign, nonatomic) BOOL isCantGetLocationServiceYES;
@property (assign, nonatomic) NSNumber *userID;
@property (retain, nonatomic) GHUser *user;
@property (retain, nonatomic) NSString *facebookID;
@property (retain, nonatomic) NSDictionary *dicCity;
@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) BOOL isShowAletForLocationServicesYES;
@property (retain, nonatomic) NSDictionary *dicCitySearchParam;
@property (retain, nonatomic) NSArray *dicDistrictSearchParam;
@property (retain, nonatomic) NSArray *dicPublicLocation;
@property (retain, nonatomic) NSArray *dicCuisineSearchParam;
@property (retain, nonatomic) NSArray *dicPurposeSearchParam;
@property (retain, nonatomic) NSArray *dicUtilitiesSearchParam;
@property (retain, nonatomic) NSMutableArray *dicPriceSearchParam;
@property (retain, nonatomic) NSMutableArray *dicCatSearchParam;
@property (retain,nonatomic) NSArray* priceArr;
@property (retain,nonatomic) NSArray* catArr;
@property (retain, nonatomic) NSMutableDictionary* recentlyBranches;
@property (assign, nonatomic) int currentSearchParam;
enum {
    kSearchParamCity = 0,
    kSearchParamDistrict,
    kSearchParamCuisine,
    kSearchParamPurpose,
    kSearchParamUtilities,
    kSearchParamZone
};
-(NSDictionary *)dicCity;
+ (GlobalDataUser *)sharedAccountClient;
-(void)setGlocalDataUser:(NSDictionary *)attributes;
-(CLLocationDistance)distanceFromAddress:(CLLocationCoordinate2D)fromAdd;
-(void)userLogout;
@end
