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
#import "SBTableAlert.h"

@interface MapTableViewController : MyViewController<LocationPickerViewDelegate,UITableViewDataSource,SBTableAlertDelegate, SBTableAlertDataSource, UITableViewDelegate,SearchVCDelegate,GMSMapViewDelegate>
@property (nonatomic, strong) LocationPickerView *locationPickerView;
@property(nonatomic,strong)TVBranches *branches;
@property(nonatomic,assign)CLLocationCoordinate2D lastPosition;
@property(nonatomic,assign)float lastDistanceSearch;
@property(nonatomic,assign)CLLocationCoordinate2D currentCameraPositionSearch;
@property(nonatomic,strong)NSDate* lastUpdate;
@property(nonatomic, strong)TVNotification* notificationView;
//@property(nonatomic, strong)NSArray* arrDics;

@end
