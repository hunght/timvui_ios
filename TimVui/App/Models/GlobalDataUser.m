//
//  GlobalDataUser.m
//  TimVui
//
//  Created by Hoang The Hung on 4/17/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "GlobalDataUser.h"
#import "TVAppDelegate.h"
@implementation GlobalDataUser


static GlobalDataUser *_sharedClient = nil;

+ (GlobalDataUser *)sharedAccountClient{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GlobalDataUser alloc] init];
        [_sharedClient checkAndGetPersistenceAccount];
        _sharedClient.locationManager = [[CLLocationManager alloc] init];
        [_sharedClient.locationManager setDelegate:_sharedClient];
        [_sharedClient.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [_sharedClient.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        _sharedClient.user=[[GHUser alloc] init];
    });
    return _sharedClient;
}

-(void)savePersistenceAccountWithData:(NSDictionary*)JSON{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:JSON forKey:kAccountUserJSON];
    [defaults synchronize];
}

- (void)checkAndGetPersistenceAccount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* JSON=[defaults valueForKey:kAccountUserJSON];
    if (JSON) [self setUserWithDic:JSON];
}

- (void)setUserWithDic:(NSDictionary *)JSON {
    self.isLogin=YES;
    [self.user setValues:[JSON valueForKey:@"data"]];
    self.facebookID=[JSON valueForKey:@""];
}

-(void)setGlocalDataUser:(NSDictionary *)JSON{
    [self setUserWithDic:JSON];
    [self savePersistenceAccountWithData:JSON];
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
        [_locationManager startMonitoringSignificantLocationChanges];
        [self sendBackgroundLocationToServer:(_userLocation)];
    }else{
        //
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"%@",error);
}

@end
