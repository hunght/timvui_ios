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
#import "TSMessage.h"
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
    [self getPublicIPFromSomewhere];
     
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
    if ([CLLocationManager locationServicesEnabled]==NO) {
        
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Location Service Disabled"
                                        withMessage:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                           withType:TSMessageNotificationTypeError
                                       withDuration:10.0
                                       withCallback:nil
                                         atPosition:TSMessageNotificationPositionTop];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Location Service Disabled"
                                        withMessage:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                           withType:TSMessageNotificationTypeError
                                       withDuration:10.0
                                       withCallback:nil
                                         atPosition:TSMessageNotificationPositionTop];
    }else{
        // Do any additional setup after loading the view from its nib.
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
    if ([CLLocationManager locationServicesEnabled]==NO||([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)){
        [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MapTableViewController alloc] initWithNibName:@"MapTableViewController" bundle:nil] afterDelay:0.0];
    }
}

-(void)getPublicIPFromSomewhere{
       
    NSURL *iPURL = [NSURL URLWithString:@"http://api.externalip.net/ip/"];
    
    // 1
    NSURLRequest *request = [NSURLRequest requestWithURL:iPURL];
    
    // 2
    AFHTTPRequestOperation *operation =
    [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // 5
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success:%@",operation.responseString);
        [self didReceivePublicIPandPort:operation.responseString];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure");
        [self didReceivePublicIPandPort:@"118.70.176.113"];
    }];
    [operation start];
    
}

-(void)didReceivePublicIPandPort:(NSString *) data{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            data,@"decimal_ip",
                            nil];
    [[TVNetworkingClient sharedClient] postPath:@"data/getCityByIp" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        [GlobalDataUser sharedAccountClient].dicCity=[JSON valueForKey:@"data"];
        [GlobalDataUser sharedAccountClient].userLocation=[[JSON valueForKey:@"data"] safeLocationForKey:@"latlng"];
        [self checkLocationServiceAvaible];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkLocationServiceAvaible];
    }];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [GlobalDataUser sharedAccountClient].userLocation=newLocation.coordinate;
    NSLog(@"%f",newLocation.coordinate.latitude);
    [_locationManager stopMonitoringSignificantLocationChanges];
    [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MapTableViewController alloc] initWithNibName:@"MapTableViewController" bundle:nil] afterDelay:0.0];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager stopMonitoringSignificantLocationChanges];
    [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MapTableViewController alloc] initWithNibName:@"MapTableViewController" bundle:nil] afterDelay:0.0];
}

@end
