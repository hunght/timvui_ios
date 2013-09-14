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
@interface WelcomeVC ()
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
        [GlobalDataUser sharedAccountClient].isCantGetLocationServiceYES=YES;
    }else{
        // Do any additional setup after loading the view from its nib.
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        [self.locationManager startMonitoringSignificantLocationChanges];

        [self performSelector:@selector(checkLocationServiceAvaible) withObject:nil afterDelay:1];
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
            NSLog(@"%@",dic);
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
    [[TVNetworkingClient sharedClient] postPath:@"data/getCityByLatlng" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        //        NSLog(@"%@",JSON);
        [GlobalDataUser sharedAccountClient].dicCity=[JSON valueForKey:@"data"];
        [[GlobalDataUser sharedAccountClient].locationManager startMonitoringSignificantLocationChanges];
        [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MapTableViewController alloc] initWithNibName:@"MapTableViewController" bundle:nil] afterDelay:0.0];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[RecentlyBranchListVC alloc] initWithNibName:@"RecentlyBranchListVC" bundle:nil] afterDelay:0.0];
    }];
}

-(void)didReceivePublicIPandPort:(NSString *) data{
    SharedAppDelegate.getCityDistrictData=[[NSUserDefaults standardUserDefaults] valueForKey:kGetCityDistrictData];
    
    [self getDataParamsPath:@"data/getCityDistrictData" laterThanDays:7 checkDictionary:SharedAppDelegate.getCityDistrictData forKey:kGetCityDistrictData forData:data];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [GlobalDataUser sharedAccountClient].userLocation=newLocation.coordinate;
    NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    [GlobalDataUser sharedAccountClient].isCantGetLocationServiceYES=NO;
    [self didReceivePublicIPandPort:strLatLng];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkLocationServiceAvaible) object: nil];
    [_locationManager stopMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self didReceivePublicIPandPort:@"21.033333,105.850000"];
    CLLocationCoordinate2D location;
	location.latitude=21.033333;
    location.longitude=105.850000;
    [GlobalDataUser sharedAccountClient].userLocation=location;
    [GlobalDataUser sharedAccountClient].isCantGetLocationServiceYES=YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkLocationServiceAvaible) object: nil];
    [_locationManager stopMonitoringSignificantLocationChanges];
}

@end
