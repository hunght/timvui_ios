//
//  UINavigationBar+JTDropShadow.h
//
//  Created by james on 9/20/11.
//  http://ioscodesnippet.tumblr.com
//

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#import <UIKit/UIKit.h>

@interface UINavigationBar (JTDropShadow)

- (void)dropShadow;
-(void)setNavigationBarWithoutIcon:(BOOL)isYES;
@end

#endif