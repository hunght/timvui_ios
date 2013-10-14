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
#import "TVCoupons.h"
#import "TVCoupon.h"
#import "MacroApp.h"
@interface GlobalDataUser(){
    NSTimer *myTimer;
    CLLocation *bestEffortAtLocation;
}

@end

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
        [self checkAndGetPersistenceAccount];
        _dicCatSearchParam=[[NSMutableArray alloc] init];
        _dicPriceSearchParam=[[NSMutableArray alloc] init];
        _recentlyBranches=[[NSMutableArray alloc] init];
        _receivedCouponIDs=[[NSMutableDictionary alloc] init];
        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"isWantToOnVirateYES"]) {
            _isHasNearlyBranchesYES=[NSNumber numberWithBool:YES];
            _isNearlyBranchesHasNewCouponYES=[NSNumber numberWithBool:YES];
            _isFollowBranchesHasNewCouponYES=[NSNumber numberWithBool:YES];
            _isWantToOnVirateYES=[NSNumber numberWithBool:YES];
            [self setSettingNotificationUser];
        }else{
            [self getSettingNotificationUser];
        }
    }
    return self;
}

-(void)stopSignificationLocation{
    [self locationManagerStop];
    if (myTimer&& [myTimer isValid]) {
        [myTimer invalidate];
        myTimer = nil;
    }
}

-(void)startSignificationLocation{
    if ([SharedAppDelegate isConnected]&& _isTurnOffReviewYES) {
        if (!_isNearlyBranchesHasNewCouponYES.boolValue && !_isHasNearlyBranchesYES.boolValue) {
            return;
        }
        UIBackgroundTaskIdentifier bgTask = 0;
        UIApplication  *app = [UIApplication sharedApplication];
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:bgTask];
        }];
        
        if (myTimer&& [myTimer isValid]) {
            [myTimer invalidate];
            myTimer = nil;
        }
        myTimer = [NSTimer scheduledTimerWithTimeInterval:_locationUpdateTimePriod target:self
                                                 selector:@selector(locationManagerStart) userInfo:nil repeats:YES];
        if(bgTask != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }
    }
    
    
}

-(void)locationManagerStart{
    if (![SharedAppDelegate isConnected]) {
        return;
    }
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        // _locationManager.pausesLocationUpdatesAutomatically=NO;
        [_locationManager startUpdatingLocation];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
        [self performSelector:@selector(locationManagerStop) withObject:nil afterDelay:10];
}

-(void)locationManagerStop{
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
        _locationManager.delegate=nil;
        _locationManager=nil;
    }
}

-(void)savePersistenceAccountWithData:(NSDictionary*)JSON{
    //    NSLog(@"%@",[JSON description]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[JSON JSONString] forKey:kAccountUserJSON];
    [defaults synchronize];
}

- (void)checkAndGetPersistenceAccount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* JSON=[defaults valueForKey:kAccountUserJSON];
    //    NSLog(@"%@",[JSON objectFromJSONString]);
    if (JSON){
        [self setUserWithDic:[JSON objectFromJSONString]];
        
    }
    //    NSLog(@"%@",self.user);
}

- (void)setUserWithDic:(NSDictionary *)JSON {
    self.isLogin = YES;
    NSLog(@"%@",JSON);
        [self.user setValues:JSON ];
//#warning User login set default USER ID TEST
//    self.user.userId=@"8878";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            
                            self.user.userId,@"user_id" ,
                            @"1",@"isWantID" ,
                            nil];
    NSLog(@"params =%@",params);
    [[TVNetworkingClient sharedClient] postPath:@"branch/getFavouriteBranchesByUser" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        _followBranchesSet=[[NSMutableDictionary alloc] initWithDictionary:[JSON safeDictForKey:@"data"]] ;
        NSLog(@"_followBranchesSet=%@",_followBranchesSet);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)updateNotificationSetting:(NSString*)is_notify {

//    NSLog(@"userObject = %@",[GlobalDataUser sharedAccountClient].user.userId);
//    NSLog(@"UUID = %@",[GlobalDataUser sharedAccountClient].UUID);
//    NSLog(@"_deviceToken = %@",_deviceToken);
    NSDictionary * userObject=[NSDictionary dictionaryWithObjectsAndKeys:
                               [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                               [GlobalDataUser sharedAccountClient].UUID,@"mobile_id",
                               @"IOS",@"mobile_os",
                               
                               _deviceToken,@"mobile_token",
                               is_notify,@"is_notify",
                               nil];
    NSDictionary *paramsHandBook = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [userObject JSONString],@"UserMobile" ,
                                    nil];
    NSLog(@"paramsHandBook = %@",paramsHandBook);
    [[TVNetworkingClient sharedClient] postPath:@"user/userMobileSave" parameters:paramsHandBook success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"JSON = %@",JSON);
        [self setSettingNotificationUser];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        _isFollowBranchesHasNewCouponYES=[NSNumber numberWithBool:NO];
        [self setSettingNotificationUser];
    }];
}

-(void)setGlocalDataUser:(NSDictionary *)JSON{
    [self setUserWithDic:JSON];
    [self savePersistenceAccountWithData:JSON];

}

-(void)userLogout{
    self.isLogin = NO;
    [self updateNotificationSetting:@"0"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:kAccountUserJSON];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [defaults synchronize];
}

- (void)sendBackgroundLocationToServer {
    UIBackgroundTaskIdentifier bgTask = 0;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
              }];
    
    DJLog(@"Background mode");
    if(_isHasNearlyBranchesYES.boolValue)[self checkHasNearlyBranchIsInBackGround:YES];
    if (_isNearlyBranchesHasNewCouponYES.boolValue) {
        [self checkHasCouponBranchIsInBackGround:YES];
    }
    if(bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}

-(NSDictionary *)homeCity{
    //    NSLog(@"SharedAppDelegate.getCityDistrictData=%@",SharedAppDelegate.getCityDistrictData);
    if (_homeCity) {
        return _homeCity;
    }else if (_user.city_id) {
        NSPredicate* filter = [NSPredicate predicateWithFormat:@"(city_id == %@)",_user.city_id];
        NSArray* idPublicArr = [[SharedAppDelegate.getCityDistrictData valueForKey:@"data"] filteredArrayUsingPredicate:filter];
        _homeCity=[idPublicArr lastObject];
    }
    return _homeCity;
}

#pragma mark Helper


-(CLLocationDistance)distanceFromAddress:(CLLocationCoordinate2D)fromAdd{
    if (!_isTurnOnLocationService) {
        return -1;
    }
    CLLocation* current=[[CLLocation alloc] initWithLatitude:fromAdd.latitude longitude:fromAdd.longitude];
    CLLocation*userLocal=[[CLLocation alloc] initWithLatitude:_userLocation.latitude longitude:_userLocation.longitude];
    return [current distanceFromLocation:userLocal];
}

#pragma mark CLLocationManagerDelegate

- (void)checkHasNearlyBranchIsInBackGround:(BOOL)isInBackground
{
    TVBranches*  branches=[[TVBranches alloc] initWithPath:@"search/branch"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:@"1"  forKey:@"limit"];
    [params setValue:@"0"  forKey:@"offset"];
    [params setValue:@"short"  forKey:@"infoType"];
    [params setValue:kCheckHasNearlyBranchIsInBackGround  forKey:@"distance"];
    //    NSLog(@"_dicCity=%@",_dicCity);
    [params setValue:[_homeCity safeStringForKey:@"alias"]  forKey:@"city_alias"];
    NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",_userLocation.latitude,_userLocation.longitude];
    [params setValue:strLatLng forKey:@"latlng"];
    [branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            // View map with contain all search items
            if (branches.count>0) {
                if (isInBackground) {
                    TVBranch* branch=branches[0];
                    NSDate* savedDate=[SharedAppDelegate.notifBranches objectForKey:branch.branchID];
                    
                    int day=(savedDate)?[savedDate daysAgo]:8;
                    if (day>7) {
                        
                        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                        localNotif.alertBody=[NSString stringWithFormat:@"Phát hiện %@ ở gần bạn!",branch.name];
                        
                        localNotif.alertAction = NSLocalizedString(@"View Detail", nil);
                        localNotif.soundName = @"alarmsound.caf";
                        localNotif.applicationIconBadgeNumber = 0;
                        //                    localNotif.userInfo = data;
                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
                        SharedAppDelegate.nearlyBranch=branch;
                        [SharedAppDelegate.notifBranches setValue:[NSDate date] forKey:branch.branchID];
                    }
                    
                }else{
                    [SharedAppDelegate showNotificationAboutNearlessBranch:branches[0]];
                }
            }
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [self stopSignificationLocation];
        });
    }];
}

- (void)checkHasCouponBranchIsInBackGround:(BOOL)isInBackground
{
    TVBranches*  branches=[[TVBranches alloc] initWithPath:@"search/branch"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:@"1"  forKey:@"limit"];
    [params setValue:@"0"  forKey:@"offset"];
    [params setValue:@"short"  forKey:@"infoType"];
    [params setValue:kCheckHasCouponBranchIsInBackGround  forKey:@"distance"];
    [params setValue:@"1"  forKey:@"has_coupon"];
    //    NSLog(@"_dicCity=%@",_dicCity);
    [params setValue:[_homeCity safeStringForKey:@"alias"]  forKey:@"city_alias"];
    NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",_userLocation.latitude,_userLocation.longitude];
    [params setValue:strLatLng forKey:@"latlng"];
    [branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            // View map with contain all search items
            if (branches.count>0) {
                if (isInBackground) {
                    TVBranch* branch=branches[0];
                    NSDate* savedDate=[SharedAppDelegate.notifCoupons objectForKey:[branch.coupons.items[0] couponID]];
                    int day=(savedDate)?[savedDate daysAgo]:8;
                    if (day>7) {
                        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                        localNotif.alertBody=[NSString stringWithFormat:@"%@ vừa tạo coupon mới cho thành viên Anuong.net!",branch.name];
                        localNotif.alertAction = NSLocalizedString(@"View Detail", nil);
                        localNotif.soundName = @"alarmsound.caf";
                        localNotif.applicationIconBadgeNumber = 0;
                        //localNotif.userInfo = data;
                        
                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
                        SharedAppDelegate.hasCouponBranch=branches[0];
                        
                        [SharedAppDelegate.notifCoupons setValue:[NSDate date] forKey:[branch.coupons.items[0] couponID]];
                    }
                }else{
                    
                    [SharedAppDelegate showNotificationAboutNearlessBranch:branches[0]];
                }
            }
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [self stopSignificationLocation];
        });
    }];
}



-(void)getSettingNotificationUser{
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    self.isWantToOnVirateYES=(NSNumber *)[userDefaults valueForKey:@"isWantToOnVirateYES"];
    self.isNearlyBranchesHasNewCouponYES=(NSNumber *)[userDefaults valueForKey:@"isNearlyBranchesHasNewCouponYES"];
    self.isFollowBranchesHasNewCouponYES=(NSNumber *)[userDefaults valueForKey:@"isFollowBranchesHasNewCouponYES"];
    self.isHasNearlyBranchesYES=[(NSNumber *)userDefaults valueForKey:@"isHasNearlyBranchesYES"];
}

-(void)setSettingNotificationUser{
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.isWantToOnVirateYES forKey:@"isWantToOnVirateYES"];
    [userDefaults setValue:self.isNearlyBranchesHasNewCouponYES forKey:@"isNearlyBranchesHasNewCouponYES"];
    [userDefaults setValue:self.isFollowBranchesHasNewCouponYES forKey:@"isFollowBranchesHasNewCouponYES"];
    [userDefaults setValue:self.isHasNearlyBranchesYES forKey:@"isHasNearlyBranchesYES"];
    [userDefaults synchronize];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"_userLocation lat=%f, lon=%f",_userLocation.latitude, _userLocation.longitude);
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            //
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [GlobalDataUser sharedAccountClient].userLocation=bestEffortAtLocation.coordinate;

            [self locationManagerStop];
        }
    }
    
    _userLocation = newLocation.coordinate;
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        isInBackground = YES;
    }
    double distance=[self distanceFromAddress:newLocation.coordinate];
    if ( distance<100) {
        if(isInBackground) {
            [self sendBackgroundLocationToServer];
        }else{
            if(_isHasNearlyBranchesYES.boolValue)[self checkHasNearlyBranchIsInBackGround:YES];
            if (_isNearlyBranchesHasNewCouponYES.boolValue) {
                [self checkHasCouponBranchIsInBackGround:YES];
            }
        }
    }
    [self locationManagerStop];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [self locationManagerStop];
}

@end
