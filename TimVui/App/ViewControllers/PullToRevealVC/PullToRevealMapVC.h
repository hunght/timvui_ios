//
//  PullToRevealViewController.h
//  PullToReveal
//
//  Created by Marcus Kida on 02.11.12.
//  Copyright (c) 2012 Marcus Kida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "TVBranch.h"
#import "TVBranches.h"
@protocol PullToRevealDelegate <NSObject>

@optional
- (void) PullToRevealDidSearchFor:(NSString *)searchText;

@end

@interface PullToRevealMapVC : UITableViewController<UIGestureRecognizerDelegate,GMSMapViewDelegate>

@property (nonatomic, assign) id <PullToRevealDelegate> pullToRevealDelegate;
@property (nonatomic, retain) GMSMapView *mapView;
@property (nonatomic, retain) UIButton *btnSearchBar;
@property(nonatomic,strong)TVBranches *branches;
-(void)showBranchOnMap;
@end


