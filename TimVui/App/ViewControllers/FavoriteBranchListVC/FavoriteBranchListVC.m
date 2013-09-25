//
//  RecentlyBranchListVC.m
//  Anuong
//
//  Created by Hoang The Hung on 7/9/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "FavoriteBranchListVC.h"
#import "TVBranch.h"
#import "BranchMainCell.h"
#import "TVAppDelegate.h"
#import "TVCoupon.h"
#import "TVCoupons.h"
#import "BranchProfileVC.h"
#import "GlobalDataUser.h"
#import "NSDictionary+Extensions.h"
#import "SVPullToRefresh.h"

static const NSString* limitCount=@"5";

@interface FavoriteBranchListVC (){
    int offset;
    UILabel *tableFooter;
}

@end

@implementation FavoriteBranchListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _branches=[[TVBranches alloc] initWithPath:@"branch/getFavouriteBranchesByUser"];
        _branches.isNotSearchAPIYES=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect footerRect = CGRectMake(0, 0, 320, 40);
    tableFooter = [[UILabel alloc] initWithFrame:footerRect];
    tableFooter.textColor = [UIColor grayColor];
    tableFooter.textAlignment=UITextAlignmentCenter;
    tableFooter.backgroundColor = [UIColor clearColor];
    tableFooter.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    tableFooter.hidden=YES;
    [tableFooter setText:@"Không còn địa điểm nào"];
    self.tableView.tableFooterView = tableFooter;
    [self postGetBranches];
    
    __weak FavoriteBranchListVC *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        NSLog(@"weakSelf.tableView.infiniteScrollingView.state=%d",weakSelf.tableView.infiniteScrollingView.state);
        if (weakSelf.tableView.infiniteScrollingView.state!=SVInfiniteScrollingStateLoading) {
            weakSelf.tableView.showsInfiniteScrolling=YES;
            offset=0;
            [weakSelf postGetBranches];
        }
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"weakSelf.tableView.pullToRefreshView.state=%d",weakSelf.tableView.pullToRefreshView.state);
        if (weakSelf.tableView.pullToRefreshView.state!=SVInfiniteScrollingStateLoading) {
            [weakSelf postGetBranches];
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


-(void)postGetBranches{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys://@"short",@"infoType",
                            [GlobalDataUser sharedAccountClient].user.userId ,@"user_id" ,
                            limitCount,@"limit",
                            [NSString stringWithFormat:@"%d",offset],@"offset",
                            nil];
    
    NSLog(@"params=%@",params);
    if (offset==0) {
        [self.branches.items removeAllObjects];
    }
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    [weakSelf.branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            
            NSLog(@"weakSelf.branches.count=%d",weakSelf.branches.count);
            NSLog(@"countAddedItems=%d",weakSelf.branches.countAddedItems);
            if (weakSelf.branches.countAddedItems==0) {
                weakSelf.tableView.showsInfiniteScrolling=NO;
                
                tableFooter.hidden=NO;
            }else{
                tableFooter.hidden=YES;
            }

            [GlobalDataUser sharedAccountClient].followBranchesSet=[NSMutableSet setWithArray:[[data safeArrayForKey:@"data"] valueForKey:@"id"]] ;
            offset+=limitCount.intValue;
            [self.tableView reloadData];
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
            
        });
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.branches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    BranchMainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BranchMainCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else{
        [[cell.utility subviews]  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    double distance=[[GlobalDataUser sharedAccountClient] distanceFromAddress:[self.branches[indexPath.row]latlng]];
    [cell setBranch:self.branches[indexPath.row] withDistance:distance];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BranchMainCell heightForCellWithPost:self.branches[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    BranchProfileVC* branchProfileVC=[[BranchProfileVC alloc] initWithNibName:@"BranchProfileVC" bundle:nil];
    
    branchProfileVC.branchID=[_branches[indexPath.row] branchID] ;
    [self.navigationController pushViewController:branchProfileVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
