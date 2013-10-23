//
//  RecentlyBranchListVC.h
//  Anuong
//
//  Created by Hoang The Hung on 7/9/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVBranches.h"
@interface RecentlyBranchListVC : MyViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic) TVBranches* branches;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
