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
        [_sharedClient getPersistenceAccount];
        _sharedClient.locationManager = [[CLLocationManager alloc] init];
        [_sharedClient.locationManager setDelegate:_sharedClient];
        [_sharedClient.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [_sharedClient.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        _sharedClient.user=[[GHUser alloc] init];
    });
    return _sharedClient;
}

-(void)savePersistenceAccount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.userID forKey:kAccountUserID];
	[defaults setValue:self.user forKey:kAccountUserName];
	[defaults setValue:self.facebookID forKey:kAccountFacebookID];
	[defaults setValue:self.user.avatar forKey:kAccountAvatarImageURL];
    [defaults setValue:[NSNumber numberWithBool:self.isLogin] forKey:kAccountAvatarImageURL];
    [defaults synchronize];
}

- (void)getPersistenceAccount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userID=[defaults valueForKey:kAccountUserID];
	self.user=[defaults valueForKey:kAccountUserName];
	self.facebookID=[defaults valueForKey:kAccountFacebookID];
	self.user.avatar=[defaults valueForKey:kAccountAvatarImageURL];
    self.isLogin=[[defaults valueForKey:kAccountAvatarImageURL] boolValue];
}

+(void)setGlocalDataUser:(NSDictionary *)attributes{
    _sharedClient.userID = [attributes valueForKeyPath:@"id"] ;
    _sharedClient.user = [attributes valueForKeyPath:@"username"];
    _sharedClient.user.avatar= [attributes valueForKeyPath:@"avatar_image.url"];
}


- (void)sendBackgroundLocationToServer:(CLLocationCoordinate2D )location {
    UIBackgroundTaskIdentifier bgTask = 0;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
              }];
    
    // Send position to server synchronously since we won't block any UI in the background...
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
