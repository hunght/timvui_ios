//
//  ReceivedCoupon.m
//  Anuong
//
//  Created by Hoang The Hung on 8/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "NearbyCouponVC.h"
#import "NearbyCouponCell.h"
#import "TVBranch.h"
#import "TVNetworkingClient.h"
#import "GlobalDataUser.h"
#import "NSDictionary+Extensions.h"
#import "TVCoupon.h"
#import "CoupBranchProfileVC.h"
static const NSString* limitCount=@"10";
static const NSString* distanceMapSearch=@"100";

@interface NearbyCouponVC ()
{
    @private
    NSMutableArray* arrCoupons;
    NSNumber* offset;
}
@end

@implementation NearbyCouponVC



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _branches=[[TVBranches alloc] initWithPath:@"search/getBranchesHaveCoupon"];
        _branches.isNotSearchAPIYES=NO;
        arrCoupons=[[NSMutableArray alloc] init];
        offset=[[NSNumber alloc] initWithInt:0];
    }
    return self;
}

- (void)postToGetBranches
{
    NSDictionary *params = nil;
    CLLocationCoordinate2D location=[GlobalDataUser sharedAccountClient].userLocation;
    
    if (location.latitude) {
        NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",location.latitude,location.longitude];
        params = @{@"city_alias": [[GlobalDataUser sharedAccountClient].dicCity safeStringForKey:@"alias"],
                   @"latlng": strLatLng,@"limit":limitCount,@"offset":offset.stringValue,@"distance":distanceMapSearch};
    }else
    {
        NSLog(@"Can't get location of user");
    }
    
    NSLog(@"param=%@",params);
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    [weakSelf.branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (weakSelf.branches.count==0) {
                
            }else{
                for (TVBranch* branch in _branches.items) {
                    for (TVCoupon* coupon in branch.coupons.items) {
                        coupon.branch=branch;
                        [arrCoupons addObject:coupon];
                        [self.tableView reloadData];
                    }
                }
            }
            
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
        });
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
    self.tableView.backgroundColor=[UIColor clearColor];
    [self postToGetBranches];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrCoupons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyCouponCell* cell;
    
    NSString* strCellIdentifier=@"NearbyCouponCell";
    cell = [tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    if (!cell) {
        cell = [[NearbyCouponCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCellIdentifier];
    }
    
    TVCoupon* coupon=arrCoupons[indexPath.row];
    [cell setCoupon:coupon];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TVCoupon* coupon    =arrCoupons[indexPath.row];
    return [NearbyCouponCell heightForCellWithPost:coupon];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    TVCoupon* coupon=arrCoupons[indexPath.row];
    CoupBranchProfileVC* specBranchVC=[[CoupBranchProfileVC alloc] initWithNibName:@"CoupBranchProfileVC" bundle:nil];
    specBranchVC.branchID=coupon.branch.branchID;
    specBranchVC.coupon=coupon;
    [self.navigationController pushViewController:specBranchVC animated:YES];
    
}

@end
