//
//  BranchProfileVC.h
//  TimVui
//
//  Created by Hoang The Hung on 6/5/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVBranch.h"
#import "TVExtraBranchView.h"
@interface BranchProfileVC : UIViewController<UIScrollViewDelegate>
@property (retain, nonatomic) TVBranch *branch;
@property (retain, nonatomic) TVExtraBranchView *extraBranchView;


@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgBranchCover;

@end
