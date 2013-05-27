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
#import "PortMapper.h"
@interface WelcomeVC ()

@end

@implementation WelcomeVC


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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [SharedAppDelegate.menuVC openViewController:[[MainVC alloc] initWithStyle:UITableViewStylePlain]];
    }else{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [PortMapper findPublicAddress],@"decimal_ip",
                                nil];
        NSLog(@"%@",params);
        [[TVNetworkingClient sharedClient] postPath:@"http://anuong.hehe.vn/api/user/login" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSLog(@"%@",JSON);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
