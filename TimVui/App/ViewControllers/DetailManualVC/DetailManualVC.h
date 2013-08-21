//
//  DetailManualVC.h
//  Anuong
//
//  Created by Hoang The Hung on 7/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVBranches.h"
@class TVManual;
@interface DetailManualVC : UIViewController<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    @private
    UIView* _couponBranch;
}
@property(strong, nonatomic) TVBranches* branches;
@property (nonatomic)UIButton* btnListView;
@property (nonatomic)UIButton* btnMapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withManual:(TVManual*)manual;
@end
