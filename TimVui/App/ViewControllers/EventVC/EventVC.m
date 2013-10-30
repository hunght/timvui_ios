//
//  ReceivedCoupon.m
//  Anuong
//
//  Created by Hoang The Hung on 8/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "EventVC.h"
#import "TVEventCell.h"
#import "TVBranch.h"
#import "TVNetworkingClient.h"
#import "GlobalDataUser.h"
#import "NSDictionary+Extensions.h"
#import "TVEvent.h"
#import "SVPullToRefresh.h"
#import "BranchProfileVC.h"
static const NSString* limitCount=@"5";
static const NSString* distanceMapSearch=@"100";

@interface EventVC ()
{
    @private
    NSMutableArray* arrEvents;
    int offset;
    UILabel *tableFooter;
}
@end

@implementation EventVC



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _branches=[[TVBranches alloc] initWithPath:@"search/getBranchesHaveEvent"];
        _branches.isNotSearchAPIYES=NO;
        arrEvents=[[NSMutableArray alloc] init];
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
        params = @{@"city_id": [[GlobalDataUser sharedAccountClient].homeCity safeStringForKey:@"id"],
                   @"latlng": strLatLng,@"limit":limitCount,@"offset":[NSString stringWithFormat:@"%d",offset],@"distance":distanceMapSearch};
    }else
    {
        NSLog(@"Can't get location of user");
    }
    
    NSLog(@"param=%@",params);
    if (offset==0) {
        [arrEvents removeAllObjects];
        [self.branches.items removeAllObjects];
        [self.tableView reloadData];
    }
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    [weakSelf.branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            
//            NSLog(@"weakSelf.branches.count=%d",weakSelf.branches.count);
//            NSLog(@"countAddedItems=%d",weakSelf.branches.countAddedItems);
            if (weakSelf.branches.countAddedItems<limitCount.intValue) {
                weakSelf.tableView.showsInfiniteScrolling=NO;
                
                if(weakSelf.branches.count==0)tableFooter.hidden=NO;
            }else{
                tableFooter.hidden=YES;
            }
            
            for (TVBranch* branch in _branches.items) {
                for (TVEvent* event in branch.events.items) {
                    event.branch=branch;
                    [arrEvents addObject:event];
                    
                }
            }
            offset+=limitCount.intValue;
            [self.tableView reloadData];
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
        });
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect footerRect = CGRectMake(0, 0, 320, 40);
    tableFooter = [[UILabel alloc] initWithFrame:footerRect];
    tableFooter.textColor = kGrayTextColor;
    tableFooter.textAlignment=UITextAlignmentCenter;
    tableFooter.backgroundColor = [UIColor clearColor];
    tableFooter.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    tableFooter.hidden=YES;
    [tableFooter setText:@"Không còn sự kiện nào"];
    self.tableView.tableFooterView = tableFooter;
    
    [self postToGetBranches];
    
    __weak EventVC *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        NSLog(@"weakSelf.tableView.infiniteScrollingView.state=%d",weakSelf.tableView.infiniteScrollingView.state);
        if (weakSelf.tableView.infiniteScrollingView.state!=SVInfiniteScrollingStateLoading) {
            weakSelf.tableView.showsInfiniteScrolling=YES;
            offset=0;
            [weakSelf postToGetBranches];
        }
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"weakSelf.tableView.pullToRefreshView.state=%d",weakSelf.tableView.pullToRefreshView.state);
        if (weakSelf.tableView.pullToRefreshView.state!=SVInfiniteScrollingStateLoading) {
            [weakSelf postToGetBranches];
        }
    }];

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
    
    return [arrEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TVEventCell* cell;
    
    NSString* strCellIdentifier=@"TVEventCell";
    cell = [tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    if (!cell) {
        cell = [[TVEventCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCellIdentifier];
    }
    
    TVEvent* event=arrEvents[indexPath.row];
    [cell setEvent:event];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    BranchProfileVC* branchProfileVC=[[BranchProfileVC alloc] initWithNibName:@"BranchProfileVC" bundle:nil];
    branchProfileVC.isWantToShowEvents=YES;
    branchProfileVC.branchID=[[arrEvents[indexPath.row] branch] branchID] ;
    [self.navigationController pushViewController:branchProfileVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
