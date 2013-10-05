//
//  RecentlyBranchListVC.m
//  Anuong
//
//  Created by Hoang The Hung on 7/9/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "RecentlyBranchListVC.h"
#import "TVBranch.h"
#import "BranchMainCell.h"
#import "TVAppDelegate.h"
#import "TVCoupon.h"
#import "TVCoupons.h"
#import "BranchProfileVC.h"
#import "GlobalDataUser.h"
@interface RecentlyBranchListVC ()

@end

@implementation RecentlyBranchListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _branches=[[TVBranches alloc] initWithPath:@"branch/getById"];
        _branches.isNotSearchAPIYES=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self postGetBranches];
    // Do any additional setup after loading the view from its nib.
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
    
    if ([SharedAppDelegate isConnected]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"short",@"infoType",
                                [[GlobalDataUser sharedAccountClient].recentlyBranches valueForKey:@"id"],@"id" ,
                                nil];
        
        __unsafe_unretained __typeof(&*self)weakSelf = self;
        
        [weakSelf.branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
            dispatch_async(dispatch_get_main_queue(),^ {
                //NSLog(@"weakSelf.branches.count===%@",[weakSelf.branches[0] name]);
                [self.tableView reloadData];
                
            });
        } failure:^(GHResource *instance, NSError *error) {
            dispatch_async(dispatch_get_main_queue(),^ {
                
            });
        }];
        
    }else{
        NSLog(@"[GlobalDataUser sharedAccountClient].recentlyBranches===%@",[GlobalDataUser sharedAccountClient].recentlyBranches);
        [_branches setValues:[GlobalDataUser sharedAccountClient].recentlyBranches ];
        [self.tableView reloadData];
    }
    
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
    if (SharedAppDelegate.isHasInternetYES){
            branchProfileVC.branchID=[_branches[indexPath.row] branchID] ;
    }else {
        branchProfileVC.branch=_branches[indexPath.row] ;
    }

    [self.navigationController pushViewController:branchProfileVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
