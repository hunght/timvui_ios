//
//  MyNavigationController.m
//  TimVui
//
//  Created by Hoang The Hung on 6/4/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "MyNavigationController.h"
#import <QuartzCore/QuartzCore.h>
@interface MyNavigationController ()

@end

@implementation MyNavigationController
-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        [self setNavigationBarWithoutIcon:YES];
    }
    return self;
}
-(id)initWithRootViewControllerNoIcon:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        [self setNavigationBarWithoutIcon:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setNavigationBarWithoutIcon:(BOOL)isYES{
    if (isYES) {
        if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_navigation"] forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"img_navigation" ofType:@"png"];
            [self.navigationBar.layer setContents:(id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
        }
    }else{
        if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_navigation_with_icon"] forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"img_navigation_with_icon" ofType:@"png"];
            [self.navigationBar.layer setContents:(id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
        }
    }
}

@end
