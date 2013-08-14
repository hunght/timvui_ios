//
//  BranchProfileVC.h
//  TimVui
//
//  Created by Hoang The Hung on 6/5/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVBranch.h"
@class TVCoupon;
@interface CoupBranchProfileVC : UIViewController<UIWebViewDelegate>
@property (retain, nonatomic) TVBranch *branch;
@property (retain, nonatomic) TVCoupon *coupon;
@property (retain, nonatomic) UIView* couponBranch;
@property (retain, nonatomic) NSString *branchID;

@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgBranchCover;

@end
