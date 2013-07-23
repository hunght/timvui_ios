//
//  UINavigationBar+JTDropShadow.m
//
//  Created by james on 9/20/11.
//  http://ioscodesnippet.tumblr.com
//

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#import "UINavigationBar+JTDropShadow.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (JTDropShadow)

- (void)dropShadow
{
   CGSize offset= CGSizeMake(0,2);
   CGFloat  radius=2.0f;
   CGFloat opacity=0.6;
    UIColor* color=[UIColor blackColor];
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self setBackgroundImage:[UIImage imageNamed:@"img_navigation_with_icon"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"img_navigation_with_icon" ofType:@"png"];
        [self.layer setContents:(id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
    }
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.layer.shadowColor   = color.CGColor;
    self.layer.shadowOffset  = offset;
    self.layer.shadowRadius  = radius;
    self.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.clipsToBounds = NO;
}

-(void)setNavigationBarWithoutIcon:(BOOL)isYES{
    if (isYES) {
        if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            [self setBackgroundImage:[UIImage imageNamed:@"img_navigation"] forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"img_navigation" ofType:@"png"];
            [self.layer setContents:(id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
        }
    }else{
        if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            [self setBackgroundImage:[UIImage imageNamed:@"img_navigation_with_icon"] forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"img_navigation_with_icon" ofType:@"png"];
            [self.layer setContents:(id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
        }
    }
}

@end

#endif