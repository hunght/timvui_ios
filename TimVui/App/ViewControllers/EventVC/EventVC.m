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
static const NSString* limitCount=@"10";
static const NSString* distanceMapSearch=@"100";

@interface EventVC ()
{
    @private
    NSMutableArray* arrEvents;
    NSNumber* offset;
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
                    for (TVEvent* event in branch.events.items) {
                        event.branch=branch;
                        [arrEvents addObject:event];
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
    TVEvent* manual=arrEvents[indexPath.row];
    return 270 + [TVEventCell heightForCellWithPost:manual];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
