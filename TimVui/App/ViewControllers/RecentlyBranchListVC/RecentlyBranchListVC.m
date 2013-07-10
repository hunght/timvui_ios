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
@interface RecentlyBranchListVC ()

@end

@implementation RecentlyBranchListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)settingForCell:(BranchMainCell *)cell indexPath:(NSIndexPath *)indexPath {
    int countUtilities=0;
    TVBranch* branch=self.branches[indexPath.row];
    
    for (NSString* strAlias in [branch utilities]) {
        NSPredicate* filter = [NSPredicate predicateWithFormat:@"(alias == %@)",strAlias];
        NSDictionary* params=[SharedAppDelegate getParamData];
        NSDictionary* dicCuisines=[[[params valueForKey:@"data"] valueForKey:@"tien-ich"] valueForKey:@"params"];
        NSArray* idPublicArr = [[dicCuisines allValues] filteredArrayUsingPredicate:filter];
        NSDictionary* utilityDic=[idPublicArr lastObject];
        
        UIImageView *iconIView = [[UIImageView alloc] initWithFrame:CGRectMake(countUtilities*(8+18),0, 18, 18)];
        [iconIView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_on",[utilityDic valueForKey:@"id"]]]];
        
        [cell.utility addSubview:iconIView];
        countUtilities++;
    }
    
    int lineHeight=25;
    
    for (TVCoupon* coupon in branch.coupons.items) {
        UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(8.0+25, lineHeight, 265, 25)];
        lblAddress.backgroundColor = [UIColor clearColor];
        lblAddress.textColor = [UIColor grayColor];
        lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(15)];
        lblAddress.numberOfLines = 0;
        lblAddress.lineBreakMode = UILineBreakModeWordWrap;
        lblAddress.text=coupon.name;
        [lblAddress sizeToFit];
        [cell.utility addSubview:lblAddress];
        
        UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, lineHeight, 25, 25)];
        homeIcon.image=[UIImage imageNamed:@"img_camera_cell_button"];
        [cell.utility addSubview:homeIcon];
        lineHeight+=lblAddress.frame.size.height+5;
    }
    
    CGRect frame=cell.utility.frame;
    frame.size.height+=branch.coupons.items.count*30;
    [cell.utility setFrame:frame];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    BranchMainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BranchMainCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [self settingForCell:cell indexPath:indexPath];
    }
    else{
        [[cell.utility subviews]  makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self settingForCell:cell indexPath:indexPath];
    }
    cell.branch = self.branches[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BranchMainCell heightForCellWithPost:self.branches[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    BranchProfileVC* branchProfileVC=[[BranchProfileVC alloc] initWithNibName:@"BranchProfileVC" bundle:nil];
    branchProfileVC.branchID=[_branches[indexPath.row] branchID];
    [self.navigationController pushViewController:branchProfileVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
