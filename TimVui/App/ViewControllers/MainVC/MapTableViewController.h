//
//  MapTableViewController.h
//  TimVui
//
//  Created by Hoang The Hung on 6/13/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationPickerView.h"
#import "UINavigationBar+JTDropShadow.h"
#import "SearchVC.h"
#import "TVBranches.h"

@interface MapTableViewController : UIViewController<LocationPickerViewDelegate,UITableViewDataSource, UITableViewDelegate,SearchVCDelegate,GMSMapViewDelegate>
@property (nonatomic, strong) LocationPickerView *locationPickerView;
@property (nonatomic, retain) UIButton *btnSearchBar;
@property(nonatomic,strong)TVBranches *branches;
@end
