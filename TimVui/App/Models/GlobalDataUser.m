//
//  GlobalDataUser.m
//  TimVui
//
//  Created by Hoang The Hung on 4/17/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "GlobalDataUser.h"
#import "TVAppDelegate.h"
#import <JSONKit.h>
#import "TVBranches.h"
#import "NSDictionary+Extensions.h"
#import "NSDate-Utilities.h"
@implementation GlobalDataUser


static GlobalDataUser *_sharedClient = nil;

+ (GlobalDataUser *)sharedAccountClient{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GlobalDataUser alloc] init];
        _sharedClient.user=[[GHUser alloc] init];
        _sharedClient.locationManager = [[CLLocationManager alloc] init];
        [_sharedClient.locationManager setDelegate:_sharedClient];
        [_sharedClient.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [_sharedClient.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        [_sharedClient checkAndGetPersistenceAccount];
        _sharedClient.dicCatSearchParam=[[NSMutableArray alloc] init];
        _sharedClient.dicPriceSearchParam=[[NSMutableArray alloc] init];
        _sharedClient.recentlyBranches=[[NSMutableDictionary alloc] init];
    });
    
    return _sharedClient;
}

-(void)savePersistenceAccountWithData:(NSDictionary*)JSON{
    NSLog(@"%@",[JSON description]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[JSON JSONString] forKey:kAccountUserJSON];
    [defaults synchronize];
}

- (void)checkAndGetPersistenceAccount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* JSON=[defaults valueForKey:kAccountUserJSON];
    NSLog(@"%@",[JSON objectFromJSONString]);
    if (JSON)
        [self setUserWithDic:[JSON objectFromJSONString]];
    NSLog(@"%@",self.user);
}

- (void)setUserWithDic:(NSDictionary *)JSON {
    self.isLogin = YES;
    NSLog(@"%@",JSON);
    [self.user setValues:JSON ];
    self.facebookID=[JSON valueForKey:@""];
    
    #warning User login set default USER ID TEST
    self.user.userId=@"8878";
}

-(void)setGlocalDataUser:(NSDictionary *)JSON{
    [self setUserWithDic:JSON];
    [self savePersistenceAccountWithData:JSON];
}

-(void)userLogout{
    self.isLogin = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:kAccountUserJSON];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [defaults synchronize];
}

- (void)sendBackgroundLocationToServer:(CLLocationCoordinate2D )location {
    UIBackgroundTaskIdentifier bgTask = 0;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
              }];
    
    DJLog(@"Background mode");
    
    if(bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}

-(NSDictionary *)dicCity{
    NSLog(@"SharedAppDelegate.getCityDistrictData=%@",SharedAppDelegate.getCityDistrictData);
    if (_dicCity) {
        return _dicCity;
    }else if (_user.city_id) {
        NSPredicate* filter = [NSPredicate predicateWithFormat:@"(city_id == %@)",_user.city_id];
        NSArray* idPublicArr = [[SharedAppDelegate.getCityDistrictData valueForKey:@"data"] filteredArrayUsingPredicate:filter];
        _dicCity=[idPublicArr lastObject];
    }
    return _dicCity;
}

#pragma mark Helper

-(CLLocationDistance)distanceFromAddress:(CLLocationCoordinate2D)fromAdd{
    CLLocation* current=[[CLLocation alloc] initWithLatitude:fromAdd.latitude longitude:fromAdd.longitude];
    CLLocation*userLocal=[[CLLocation alloc] initWithLatitude:_userLocation.latitude longitude:_userLocation.longitude];
    return [current distanceFromLocation:userLocal];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _userLocation = newLocation.coordinate;
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        isInBackground = YES;
    }
    
    if(isInBackground) {
        [self sendBackgroundLocationToServer:_userLocation];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* strDate=[defaults valueForKey:kLastUpdatedLocationSendingToServer];
        if (strDate) {
            ;
            NSTimeInterval ti = -[[NSDate dateFromString:strDate] timeIntervalSinceDate:[NSDate date]];
            int minutes=ti / D_MINUTE;
            if (minutes<20) {
                return;
            }
        }

        TVBranches*  branches=[[TVBranches alloc] initWithPath:@"search/branch"];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setValue:@"1"  forKey:@"limit"];
        [params setValue:@"0"  forKey:@"offset"];
        [params setValue:@"short"  forKey:@"infoType"];
        [params setValue:@"20"  forKey:@"distance"];
        [params setValue:[_dicCity safeStringForKey:@"alias"]  forKey:@"city_alias"];
        NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",_userLocation.latitude,_userLocation.longitude];
        [params setValue:strLatLng forKey:@"latlng"];
        [branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
            dispatch_async(dispatch_get_main_queue(),^ {
                
                [defaults setValue:[[NSDate date] stringWithDefautFormat] forKey:kLastUpdatedLocationSendingToServer];
                [defaults synchronize];
                // View map with contain all search items
                if (branches.count>0) {
                    [SharedAppDelegate showNotificationAboutNearlessBranch:branches[0]];
                }
            });
        } failure:^(GHResource *instance, NSError *error) {
            dispatch_async(dispatch_get_main_queue(),^ {
            });
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"%@",error);
}

@end
