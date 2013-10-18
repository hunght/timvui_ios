//
//  ReceivedCoupon.m
//  Anuong
//
//  Created by Hoang The Hung on 8/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "ReceivedCouponVC.h"
#import "NearbyCouponCell.h"
#import "TVBranch.h"
#import "TVNetworkingClient.h"
#import "GlobalDataUser.h"
#import "NSDictionary+Extensions.h"
#import "TVCoupon.h"
#import "CoupBranchProfileVC.h"
#import "Utilities.h"
#import "TVAppDelegate.h"
#import "TSMessage.h"
#import "SVPullToRefresh.h"
static const NSString* limitCount=@"30";

@interface ReceivedCouponVC ()
{
@private
    NSMutableArray* arrCoupons;
    
    int offset;
    UILabel *tableFooter;
}

@end

@implementation ReceivedCouponVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _branches=[[TVBranches alloc] initWithPath:@"coupon/getCouponByPhone"];
        _branches.isNotSearchAPIYES=YES;
        arrCoupons=[[NSMutableArray alloc] init];
        offset=0;
    }
    return self;
}

-(void)rearrangeBranchesToShowing{
    for (TVBranch* branch in _branches.items) {
        for (TVCoupon* coupon in branch.coupons.items) {
            NSLog(@"coupon.couponID= %@",coupon.couponID);
            [[GlobalDataUser sharedAccountClient].receivedCouponIDs setValue:coupon.couponID forKey:coupon.couponID];
            coupon.branch = branch;
            [arrCoupons addObject:coupon];
        }
    }
    [self.tableView reloadData];
}

- (void)postToGetBranchesWithEnable:(BOOL)isYES
{
    NSDictionary *params = nil;
    NSString* isEnable=(isYES)?@"1":@"0";
    NSRange range = NSMakeRange(0, 1);
    NSMutableString * strPhoneNumber=[NSMutableString stringWithString:[GlobalDataUser sharedAccountClient].phoneNumber];
    [strPhoneNumber replaceCharactersInRange:range withString:@"84"];
    params = @{
               @"phone":strPhoneNumber,
               @"limit":limitCount,
               @"isStatusEnable":isEnable,
               @"offset":[NSString stringWithFormat:@"%d",offset]};
    
    NSLog(@"param=%@",params);
    
    [self.branches.items removeAllObjects];
    if (offset==0) {
        [arrCoupons removeAllObjects];
        [self.tableView reloadData];
    }
    
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    [weakSelf.branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            
            if (offset==0){
                if (isYES) {

                    NSDictionary* dataDic=data;
                    [dataDic savePersistencyWithKey:kReceivedEnabledCoupon];

                }else{
                    NSDictionary* dataDic=data;
                    [dataDic savePersistencyWithKey:kReceivedCoupon];
                }
            }
            
            if (weakSelf.branches.countAddedItems<limitCount.intValue) {
                weakSelf.tableView.showsInfiniteScrolling=NO;
                tableFooter.hidden=NO;
            }else{
                tableFooter.hidden=YES;
            }
            if (weakSelf.branches.count!=0) {
                [self rearrangeBranchesToShowing];
            }else
                [self.tableView reloadData];
            offset+=limitCount.intValue;
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
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
    [_btnActive setBackgroundImage:[Utilities imageFromColor:kDeepOrangeColor] forState:UIControlStateNormal];
    [_btnExperied setBackgroundImage:[Utilities imageFromColor:kDeepOrangeColor] forState:UIControlStateNormal];
    
    [_btnActive setBackgroundImage:[Utilities imageFromColor:[UIColor clearColor]] forState:UIControlStateSelected];
    [_btnExperied setBackgroundImage:[Utilities imageFromColor:[UIColor clearColor]] forState:UIControlStateSelected];
    
    [_btnActive setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_btnExperied setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [_btnActive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnExperied setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_btnActive.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:(15)]] ;
    [_btnExperied.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:(15)]];
    [_btnExperied setSelected:NO];
    [_btnActive setSelected:YES];
    
    
    if (![GlobalDataUser sharedAccountClient].phoneNumber) {
        [GlobalDataUser sharedAccountClient].phoneNumber=[[NSUserDefaults standardUserDefaults] stringForKey:kUserPhoneNumber];
        if (![GlobalDataUser sharedAccountClient].phoneNumber) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Thông tin" message:@"Vui lòng xác nhận số điện thoại của bạn" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
        }else{
            [self getCouponWhenHasPhoneNumber];
            [TSMessage showNotificationInViewController:self
                                              withTitle:[NSString stringWithFormat:@"Bạn đang sử dụng SĐT: %@, nếu không đúng SĐT của bạn vui lòng cài đặt lại tại menu Tuỳ chọn cài đặt.",[GlobalDataUser sharedAccountClient].phoneNumber]
                                            withMessage:nil
                                               withType:TSMessageNotificationTypeSuccess withDuration:3 withCallback:nil atPosition:TSMessageNotificationPositionBottom];
        }
    }else{
        [self getCouponWhenHasPhoneNumber];
        [TSMessage showNotificationInViewController:self
                                          withTitle:[NSString stringWithFormat:@"Bạn đang sử dụng SĐT: %@, nếu không đúng SĐT của bạn vui lòng cài đặt lại tại menu Tuỳ chọn cài đặt.",[GlobalDataUser sharedAccountClient].phoneNumber]
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeSuccess];
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setBtnActive:nil];
    [self setBtnExperied:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate

- (void)getCouponWhenHasPhoneNumber {
    
    
    if (![SharedAppDelegate isConnected]) {
        NSDictionary *retrievedDictionary;
        if (_btnActive.isSelected) {
            retrievedDictionary = [NSDictionary getDictionaryFromKey:kReceivedEnabledCoupon];
        }else{
            retrievedDictionary = [NSDictionary getDictionaryFromKey:kReceivedCoupon];
        }
        
        if (retrievedDictionary) {
            NSLog(@"retrievedDictionary= %@",retrievedDictionary);
            [_branches setValues:[retrievedDictionary safeArrayForKey:@"data"]];
            [self rearrangeBranchesToShowing];
        }
    }else{
        
        CGRect footerRect = CGRectMake(0, 0, 320, 40);
        tableFooter = [[UILabel alloc] initWithFrame:footerRect];
        tableFooter.textColor = [UIColor grayColor];
        tableFooter.textAlignment=UITextAlignmentCenter;
        tableFooter.backgroundColor = [UIColor clearColor];
        tableFooter.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
        tableFooter.hidden=YES;
        [tableFooter setText:@"Không còn coupon nào"];
        self.tableView.tableFooterView = tableFooter;
        
        [self postToGetBranchesWithEnable:_btnActive.isSelected];
        
        __weak ReceivedCouponVC *weakSelf = self;
        
        // setup pull-to-refresh
        [self.tableView addPullToRefreshWithActionHandler:^{
//            NSLog(@"weakSelf.tableView.infiniteScrollingView.state=%d",weakSelf.tableView.infiniteScrollingView.state);
            if (weakSelf.tableView.infiniteScrollingView.state!=SVInfiniteScrollingStateLoading) {
                weakSelf.tableView.showsInfiniteScrolling=YES;
                offset=0;
                [weakSelf postToGetBranchesWithEnable:_btnActive.isSelected];
            }
        }];
        // setup infinite scrolling
        [self.tableView addInfiniteScrollingWithActionHandler:^{
//            NSLog(@"weakSelf.tableView.pullToRefreshView.state=%d",weakSelf.tableView.pullToRefreshView.state);
            if (weakSelf.tableView.pullToRefreshView.state!=SVInfiniteScrollingStateLoading) {
                [weakSelf postToGetBranchesWithEnable:_btnActive.isSelected];
            }
        }];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"buttonIndex: %d",buttonIndex);
    if (buttonIndex==0) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        
        NSString *phoneRegex = @"^(09\\d{8}|01\\d{9})$";
        
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        
        BOOL phoneValidates = [phoneTest evaluateWithObject:inputText];
        if(phoneValidates)
        {
            [TSMessage showNotificationInViewController:self
                                              withTitle:@"Bạn đã update số điện thoại thành công"
                                            withMessage:nil
                                               withType:TSMessageNotificationTypeSuccess];
            
            [[NSUserDefaults standardUserDefaults] setValue:inputText forKey:kUserPhoneNumber];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [GlobalDataUser sharedAccountClient].phoneNumber=inputText;
            [self getCouponWhenHasPhoneNumber];
            
        }
        else
        {
            [TSMessage showNotificationInViewController:self
                                              withTitle:@"Số điện thoại không đúng định dạng"
                                            withMessage:nil
                                               withType:TSMessageNotificationTypeWarning];
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Thông tin" message:@"SĐT phải đúng theo định dang 09******** hoặc 01*********." delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:@"Cancel",nil];
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
            
        }
    }
    
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
    TVCoupon* manual=arrCoupons[indexPath.row];
    return [NearbyCouponCell heightForCellWithPost:manual];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TVCoupon* coupon=arrCoupons[indexPath.row];
    CoupBranchProfileVC* specBranchVC=[[CoupBranchProfileVC alloc] initWithNibName:@"CoupBranchProfileVC" bundle:nil];
    specBranchVC.branchID=coupon.branch.branchID;
    specBranchVC.coupon=coupon;
    [self.navigationController pushViewController:specBranchVC animated:YES];
    
}

#pragma mark - IBAction

- (IBAction)activeButtonClicked:(id)sender {
    [_btnExperied setSelected:NO];
    [sender setSelected:YES];
    offset=0;
    [self postToGetBranchesWithEnable:_btnActive.isSelected];
}

- (IBAction)expriedButtonClicked:(id)sender {
    [_btnActive setSelected:NO];
    [sender setSelected:YES];
    offset=0;
    [self postToGetBranchesWithEnable:_btnActive.isSelected];
}
@end
