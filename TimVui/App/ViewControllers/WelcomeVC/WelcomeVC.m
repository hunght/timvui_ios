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
#import "TSMessage.h"
#import "NSDictionary+Extensions.h"
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

-(void)getPublicIPFromSomewhere{
    GCDAsyncUdpSocket *udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    STUNClient *stunClient = [[STUNClient alloc] init];
    [stunClient requestPublicIPandPortWithUDPSocket:udpSocket delegate:self];
}
#pragma mark -
#pragma mark STUNClientDelegate

-(void)didReceivePublicIPandPort:(NSDictionary *) data{
//    NSLog(@"Public IP=%@, public Port=%@, NAT is Symmetric: %@", [data objectForKey:publicIPKey],[data objectForKey:publicPortKey], [data objectForKey:isPortRandomization]);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [data objectForKey:publicIPKey],@"decimal_ip",
                            nil];
    [[TVNetworkingClient sharedClient] postPath:@"data/getCityByIp" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        [GlobalDataUser sharedAccountClient].dicCity=[JSON valueForKey:@"data"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MainVC alloc] initWithStyle:UITableViewStylePlain] afterDelay:0.0];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [GlobalDataUser sharedAccountClient].userLocation=newLocation;
    //NSLog(@"%f",newLocation.coordinate.latitude);
    [_locationManager stopMonitoringSignificantLocationChanges];
    [SharedAppDelegate.menuVC performSelector:@selector(openViewController:) withObject:[[MainVC alloc] initWithStyle:UITableViewStylePlain] afterDelay:0.0];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager stopMonitoringSignificantLocationChanges];
}


#pragma mark ViewControllerDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([CLLocationManager locationServicesEnabled]==NO) {
        [self getPublicIPFromSomewhere];
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Location Service Disabled"
                                        withMessage:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                           withType:TSMessageNotificationTypeError
                                       withDuration:10.0
                                       withCallback:nil
                                         atPosition:TSMessageNotificationPositionTop];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self getPublicIPFromSomewhere];
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
