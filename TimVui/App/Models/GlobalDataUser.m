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
#import "TVNetworkingClient.h"
#import "NSDictionary+Extensions.h"
#import "NSDate-Utilities.h"
#import "TVBranches.h"
@implementation GlobalDataUser


static GlobalDataUser *_sharedClient = nil;

+ (GlobalDataUser *)sharedAccountClient{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GlobalDataUser alloc] init];
        
    });

    return _sharedClient;
}
- (id)init
{
    if ((self = [super init]))
    {
        _user=[[GHUser alloc] init];
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        [self checkAndGetPersistenceAccount];
        _dicCatSearchParam=[[NSMutableArray alloc] init];
        _dicPriceSearchParam=[[NSMutableArray alloc] init];
        _recentlyBranches=[[NSMutableDictionary alloc] init];
        
        
    }
    return self;
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
//    NSLog(@"%@",self.user);
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
    [self checkHasNearlyBranchIsInBackGround:YES];
    
    if(bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}

-(NSDictionary *)dicCity{
//    NSLog(@"SharedAppDelegate.getCityDistrictData=%@",SharedAppDelegate.getCityDistrictData);
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

-(void)setFollowBranches{
    if (!_followBranchesSet) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys://@"short",@"infoType",
                                [GlobalDataUser sharedAccountClient].user.userId ,@"user_id" ,
                                nil];
        
        [[TVNetworkingClient sharedClient] postPath:@"branch/getFavouriteBranchesByUser" parameters:params success:^(AFHTTPRequestOperation *operation, id data) {
            dispatch_async(dispatch_get_main_queue(),^ {
               _followBranchesSet=[NSMutableSet setWithArray:[[data safeArrayForKey:@"data"] valueForKey:@"id"]] ;
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(),^ {
                
            });
        }];
    }
}

-(CLLocationDistance)distanceFromAddress:(CLLocationCoordinate2D)fromAdd{
    CLLocation* current=[[CLLocation alloc] initWithLatitude:fromAdd.latitude longitude:fromAdd.longitude];
    CLLocation*userLocal=[[CLLocation alloc] initWithLatitude:_userLocation.latitude longitude:_userLocation.longitude];
    return [current distanceFromLocation:userLocal];
}

#pragma mark CLLocationManagerDelegate

- (void)checkHasNearlyBranchIsInBackGround:(BOOL)isInBackground
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* strDate=[defaults valueForKey:kLastUpdatedLocationSendingToServer];
    if (strDate) {
        ;
        NSTimeInterval ti = -[[NSDate dateFromString:strDate] timeIntervalSinceDate:[NSDate date]];
        int minutes=ti / D_MINUTE;
        if (minutes<20) {
#warning ignore check time to send server
//            return;
        }
    }
    
    TVBranches*  branches=[[TVBranches alloc] initWithPath:@"search/branch"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:@"1"  forKey:@"limit"];
    [params setValue:@"0"  forKey:@"offset"];
    [params setValue:@"short"  forKey:@"infoType"];
    [params setValue:@"20"  forKey:@"distance"];
    NSLog(@"_dicCity=%@",_dicCity);
    [params setValue:[_dicCity safeStringForKey:@"alias"]  forKey:@"city_alias"];
    NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",_userLocation.latitude,_userLocation.longitude];
    [params setValue:strLatLng forKey:@"latlng"];
    [branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            
            [defaults setValue:[[NSDate date] stringWithDefautFormat] forKey:kLastUpdatedLocationSendingToServer];
            [defaults synchronize];
            // View map with contain all search items
            if (branches.count>0) {
                if (isInBackground) {
                    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                    localNotif.alertBody=@"Nhà hàng ngay gần bạn !";
                    localNotif.alertAction = NSLocalizedString(@"View Detail", nil);
                    localNotif.soundName = @"alarmsound.caf";
                    localNotif.applicationIconBadgeNumber = 0;
                    localNotif.userInfo = data;
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
                     SharedAppDelegate.nearlyBranch=branches[0];
                }else{
                    [SharedAppDelegate showNotificationAboutNearlessBranch:branches[0]];
                }
               
                
            }
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
        });
    }];
}

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
        [self checkHasNearlyBranchIsInBackGround:NO];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"%@",error);
}

@end
