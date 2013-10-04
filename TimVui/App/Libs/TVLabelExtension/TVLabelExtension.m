//
//  TVLabelExtension.m
//  Anuong
//
//  Created by Hoang The Hung on 10/4/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVLabelExtension.h"

@implementation TVLabelExtension

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {5, 5, 5, 5};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
