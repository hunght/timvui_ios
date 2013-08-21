//
//  FloatView.h
//  Anuong
//
//  Created by Hoang The Hung on 8/20/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatView : UIView
@property (nonatomic, strong) UIScrollView* scrollView;
- (id)initWithFrame:(CGRect)frame withScrollView:(id)scroll;
@end
