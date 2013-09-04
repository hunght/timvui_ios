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
        [GlobalDataUser sharedAccountClient].isCantGetLocationServiceYES=YES;
        [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MapTableViewController alloc] initWithNibName:@"MapTableViewController" bundle:nil] afterDelay:0.0];
    }else{
        // Do any additional setup after loading the view from its nib.
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}


-(void)didReceivePublicIPandPort:(NSString *) data{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            data,@"latlng",
                            nil];
    [[TVNetworkingClient sharedClient] postPath:@"data/getCityByLatlng" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        [GlobalDataUser sharedAccountClient].dicCity=[JSON valueForKey:@"data"];
        [[GlobalDataUser sharedAccountClient].locationManager startMonitoringSignificantLocationChanges];
        [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MapTableViewController alloc] initWithNibName:@"MapTableViewController" bundle:nil] afterDelay:0.0];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MapTableViewController alloc] initWithNibName:@"MapTableViewController" bundle:nil] afterDelay:0.0];
    }];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [GlobalDataUser sharedAccountClient].userLocation=newLocation.coordinate;
    NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    [GlobalDataUser sharedAccountClient].isCantGetLocationServiceYES=NO;
    [self didReceivePublicIPandPort:strLatLng];
    
    NSLog(@"%f",newLocation.coordinate.latitude);
    [_locationManager stopMonitoringSignificantLocationChanges];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self didReceivePublicIPandPort:@"20.882551,105.776947"];
    CLLocationCoordinate2D location;
	location.latitude=20.882551;
    location.longitude=105.776947;
    [GlobalDataUser sharedAccountClient].userLocation=location;
    [GlobalDataUser sharedAccountClient].isCantGetLocationServiceYES=YES;
    [_locationManager stopMonitoringSignificantLocationChanges];

}

@end
