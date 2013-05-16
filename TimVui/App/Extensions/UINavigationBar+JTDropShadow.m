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

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor*)color 
                     opacity:(CGFloat)opacity
{
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

@end

#endif