//
//  WelcomeVC.m
//  TimVui
//
//  Created by Hoang The Hung on 5/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "WelcomeVC.h"
#import "GlobalDataUser.h"
#import "TVAppDelegate.h"
#import "MapTableViewController.h"
#import "TVNetworkingClient.h"
#import "NSDictionary+Extensions.h"
#import "AFJSONRequestOperation.h"
#import "RecentlyBranchListVC.h"
#import "NSDate-Utilities.h"
@interface WelcomeVC (){
    CLLocation *bestEffortAtLocation;
}
@end

@implementation WelcomeVC

#pragma mark ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden=YES;
    
    [self checkLocationServiceAvaible];
    [super viewDidLoad];
}
-(void)viewDidUnload{
    [super viewDidUnload];
    self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Helper

- (void)checkLocationServiceAvaible
{
    
    if ([CLLocationManager locationServicesEnabled]==NO||([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)){
        [self didReceivePublicIPandPort:@"21.033333,105.850000"];
        CLLocationCoordinate2D location;
        location.latitude=21.033333;
        location.longitude=105.850000;
        [GlobalDataUser sharedAccountClient].userLocation=location;
        [GlobalDataUser sharedAccountClient].isCanNotGetLocationServiceYES=YES;
    }else{
        // Do any additional setup after loading the view from its nib.
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [self.locationManager startUpdatingLocation];
        [self settingDefaultLocationUserWhenDennied];
    }
}

-(void)settingDefaultLocationUserWhenDennied{
    if ([CLLocationManager locationServicesEnabled]==NO||([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)){
        [self didReceivePublicIPandPort:@"21.033333,105.850000"];
        CLLocationCoordinate2D location;
        location.latitude=21.033333;
        location.longitude=105.850000;
        [GlobalDataUser sharedAccountClient].userLocation=location;
        [GlobalDataUser sharedAccountClient].isCanNotGetLocationServiceYES=YES;
    }else{
        [self performSelector:@selector(settingDefaultLocationUserWhenDennied) withObject:nil afterDelay:1];
    }
}

- (void)getNewDataParamsFromServer:(NSString*)strPath withDic:(NSDictionary*)myDic forKey:(NSString*)key forData:(NSString*)data
{
    [[TVNetworkingClient sharedClient] getPath:strPath parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableDictionary* dic=[[NSMutableDictionary alloc] initWithDictionary:JSON] ;
        [dic setValue:[[NSDate date] stringWithDefautFormat] forKey:@"lastUpdated"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:dic forKey:key];
        [defaults synchronize];
//            NSLog(@"dic=%@",dic);
            SharedAppDelegate.getCityDistrictData=dic;
        [self getPublicIPFromServer:data];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)getDataParamsPath:(NSString *)strPath laterThanDays:(int)days checkDictionary:(NSDictionary *)dic forKey:(NSString*)key forData:(NSString *) data
{
    if (dic) {
        NSDate* date=[NSDate dateFromString:[dic valueForKey:@"lastUpdated"]];
        //        NSLog(@"date=%@",date);
        if ([date isLaterThan:days]) {
            [self getNewDataParamsFromServer:strPath withDic:dic forKey:key forData:data ];
        }else{
            [self getPublicIPFromServer:data];
        }
    }else {
        [self getNewDataParamsFromServer:strPath withDic:dic forKey:key forData:data];
    }
}

- (void)getPublicIPFromServer:(NSString *)data {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            data,@"latlng",
                            nil];
//    NSLog(@"params ==%@",params);
    
    [[TVNetworkingClient sharedClient] postPath:@"data/getCityByLatlng" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        //        NSLog(@"%@",JSON);
        [GlobalDataUser sharedAccountClient].homeCity=[JSON valueForKey:@"data"];
        [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MapTableViewController alloc] initWithNibName:@"MapTableViewController" bundle:nil] afterDelay:0.0];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[RecentlyBranchListVC alloc] initWithNibName:@"RecentlyBranchListVC" bundle:nil] afterDelay:0.0];
        
//        NSLog(@"error = %@",error);
    }];
}

-(void)didReceivePublicIPandPort:(NSString *) data{
    SharedAppDelegate.getCityDistrictData=[[NSUserDefaults standardUserDefaults] valueForKey:kGetCityDistrictData];
    
    [self getDataParamsPath:@"data/getCityDistrictData" laterThanDays:7 checkDictionary:SharedAppDelegate.getCityDistrictData forKey:kGetCityDistrictData forData:data];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
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
            NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",bestEffortAtLocation.coordinate.latitude,bestEffortAtLocation.coordinate.longitude];
            [GlobalDataUser sharedAccountClient].isCanNotGetLocationServiceYES=NO;
            [self didReceivePublicIPandPort:strLatLng];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(settingDefaultLocationUserWhenDennied) object: nil];
            [_locationManager stopUpdatingLocation];
        }
    }
    

    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self didReceivePublicIPandPort:@"21.033333,105.850000"];
    CLLocationCoordinate2D location;
	location.latitude=21.033333;
    location.longitude=105.850000;
    [GlobalDataUser sharedAccountClient].userLocation=location;
    [GlobalDataUser sharedAccountClient].isCanNotGetLocationServiceYES=YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(settingDefaultLocationUserWhenDennied) object: nil];
    [_locationManager stopMonitoringSignificantLocationChanges];
}

@end
