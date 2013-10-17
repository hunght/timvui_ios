//
//  MyRightBarButton.m
//  Anuong
//
//  Created by Hoang The Hung on 10/17/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "MyRightBarButton.h"

@implementation MyRightBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIEdgeInsets)alignmentRectInsets {
    UIEdgeInsets insets;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        insets =  UIEdgeInsetsMake(0, 0, 0, 9.0f);
    }
    else {
        //        insets = UIEdgeInsetsMake(0, 0, 0, 9.0f);
    }
    return insets;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
