//
//  UILabel+DynamicHeight.h
//  Anuong
//
//  Created by Hoang The Hung on 8/3/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  UILabel (DynamicHeight)
-(void)resizeToStretch;
-(float)expectedHeight;
-(void)resizeWidthToStretch;
-(void)resizeToStretchWidth:(int)width;
-(void)resizeWidthToStretchWidth:(int)height;
@end
