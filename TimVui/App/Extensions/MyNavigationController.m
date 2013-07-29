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
//        [self setNavigationBarWithoutIcon:YES];
//        [self dropShadowWithOffset:CGSizeMake(0, 5) radius:5 color:[UIColor blackColor] opacity:1];
    }
    return self;
}
-(id)initWithRootViewControllerNoIcon:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        [self setNavigationBarWithoutIcon:NO];
        [self dropShadowWithOffset:CGSizeMake(0, 5) radius:5 color:[UIColor blackColor] opacity:1];
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

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor*)color
                     opacity:(CGFloat)opacity
{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_navigation_with_icon"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"img_navigation_with_icon" ofType:@"png"];
        [self.navigationBar.layer setContents:(id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
    }
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.navigationBar.bounds);
    self.navigationBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.navigationBar.layer.shadowColor   = color.CGColor;
    self.navigationBar.layer.shadowOffset  = offset;
    self.navigationBar.layer.shadowRadius  = radius;
    self.navigationBar.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.navigationBar.clipsToBounds = NO;
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
