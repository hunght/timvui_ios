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
#import "MainVC.h"
#import "TVNetworkingClient.h"
//#import "PortMapper.h"
@interface WelcomeVC ()

@end

@implementation WelcomeVC

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopMonitoringSignificantLocationChanges];
    [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MainVC alloc] initWithStyle:UITableViewStylePlain] afterDelay:0.0];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager stopMonitoringSignificantLocationChanges];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"",@"decimal_ip",
                            nil];
    [[TVNetworkingClient sharedClient] postPath:@"user/login" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MainVC alloc] initWithStyle:UITableViewStylePlain] afterDelay:0.0];
}


#pragma mark ViewControllerDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
