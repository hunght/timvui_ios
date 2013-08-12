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
@interface NearbyCouponVC ()
{
    @private
    NSNumber* offset;
}
@end

@implementation NearbyCouponVC
static const NSString* limitCount=@"10";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _branches=[[TVBranches alloc] initWithPath:@"search/getBranchesHaveCoupon"];
        _branches.isNotSearchAPIYES=YES;
        offset=0;
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
                   @"latlng": strLatLng,@"limit":limitCount,@"offset":offset.stringValue,@"distance":kDistanceSearchMapDefault};
    }else
    {
        NSLog(@"Can't get location of user");
    }
    
    NSLog(@"param=%@",params);
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    [weakSelf.branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (weakSelf.branches.count==0) {
                
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
    [self postToGetBranches];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _branches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyCouponCell* cell;
    
    NSString* strCellIdentifier=@"NearbyCouponCell";
    cell = [tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    if (!cell) {
        cell = [[NearbyCouponCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCellIdentifier];
    }
    
    TVBranch* branch=_branches[indexPath.row];
    [cell setBranch:branch];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TVBranch* manual=_branches[indexPath.row];
    return 270 + [NearbyCouponCell heightForCellWithPost:manual];
}
@end
