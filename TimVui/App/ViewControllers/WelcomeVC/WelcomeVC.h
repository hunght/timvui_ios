//
//  WelcomeVC.h
//  TimVui
//
//  Created by Hoang The Hung on 5/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface WelcomeVC : UIViewController<CLLocationManagerDelegate>
@property (retain, nonatomic) CLLocationManager *locationManager;
@end
