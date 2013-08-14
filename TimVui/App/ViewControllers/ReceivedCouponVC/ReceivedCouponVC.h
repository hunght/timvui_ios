//
//  ReceivedCoupon.h
//  Anuong
//
//  Created by Hoang The Hung on 8/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVCoupons.h"
#import "TVBranches.h"
@interface ReceivedCouponVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnActive;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnExperied;
@property (strong, nonatomic) TVBranches* branches;
- (IBAction)activeButtonClicked:(id)sender;
- (IBAction)expriedButtonClicked:(id)sender;
@end
