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
@interface EventVC : MyViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TVBranches* branches;
@end
