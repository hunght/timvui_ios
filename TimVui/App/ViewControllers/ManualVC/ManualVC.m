//
//  ManualVC.m
//  Anuong
//
//  Created by Hoang The Hung on 7/11/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "ManualVC.h"
#import "TVNetworkingClient.h"
#import "GlobalDataUser.h"
#import "NSDictionary+Extensions.h"
#import "TVManualCell.h"
#import "DetailManualVC.h"
#import "TVManual.h"
#import "TSMessage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate-Utilities.h"
#import "Utilities.h"
#import "FilterVC.h"
#import <QuartzCore/QuartzCore.h> 
#import "SVPullToRefresh.h"
#import "SIAlertView.h"
#import "LoginVC.h"

static const NSString* limitCount=@"5";
@interface ManualVC ()
{
    NSMutableDictionary* params;
    int offset;
    UILabel *tableFooter;
}
@end

@implementation ManualVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _manualArr=[[NSMutableArray alloc] init];
        offset=0;
    }
    return self;
}

- (void)postToGetManual
{
//    NSLog(@"param=%@",params);
    [params setValue:limitCount forKey:@"limit"];
    [params setValue:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
     NSLog(@"params=%@",params);
    if (offset==0) {
        [_manualArr removeAllObjects];
        [_tableView reloadData];
    }
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    [[TVNetworkingClient sharedClient] postPath:@"handbook/getHandbooks" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
        NSArray* dicArray=[[JSON safeDictForKey:@"data"] allValues];
        if (dicArray.count<limitCount.intValue) {
            weakSelf.tableView.showsInfiniteScrolling=NO;
            [tableFooter setText:@"Không còn cẩm nang nào"];
            tableFooter.hidden=NO;
        }else{
            tableFooter.hidden=YES;
            for (NSDictionary* dic in dicArray) {
                TVManual* munual=[[TVManual alloc] initWithDict:dic];
                [_manualArr addObject:munual];
            }
        }

        if (_btnSaved.isSelected) {
            _lblSaveHandbookCount.text=[NSString stringWithFormat:@"%d",_manualArr.count];
        }
        offset+=limitCount.intValue;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([GlobalDataUser sharedAccountClient].isLogin && ![GlobalDataUser sharedAccountClient].userHandBookIDs) {
        NSDictionary* _params=@{@"user_id": [GlobalDataUser sharedAccountClient].user.userId,
                                @"isWantIDYES":@"1" ,
                                @"limit":@"100",
                                @"offset":@"0",
                                @"type": @"user"};
        NSLog(@"_params= %@",_params);
        [[TVNetworkingClient sharedClient] postPath:@"handbook/getHandbooks" parameters:_params success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSLog(@"gethandbook= %@",JSON);
            [GlobalDataUser sharedAccountClient].userHandBookIDs=[[NSMutableDictionary alloc] initWithDictionary:[JSON safeDictForKey:@"data"]];
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
    
    [_btnRecently setBackgroundImage:[Utilities imageFromColor:kDeepOrangeColor] forState:UIControlStateNormal];
    [_btnPopular setBackgroundImage:[Utilities imageFromColor:kDeepOrangeColor] forState:UIControlStateNormal];
    
    [_btnSaved setBackgroundImage:[Utilities imageFromColor:kDeepOrangeColor] forState:UIControlStateNormal];
    [_btnRecently setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnPopular setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSaved setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_btnRecently setBackgroundImage:[Utilities imageFromColor:[UIColor clearColor]] forState:UIControlStateSelected];
    [_btnPopular setBackgroundImage:[Utilities imageFromColor:[UIColor clearColor]] forState:UIControlStateSelected];
    
    [_btnSaved setBackgroundImage:[Utilities imageFromColor:[UIColor clearColor]] forState:UIControlStateSelected];
    [_btnRecently setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_btnPopular setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_btnSaved setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_btnRecently setSelected:YES];
    [_btnPopular setSelected:NO];
    [_btnSaved setSelected:NO];
    
    _lblSaveHandbookCount=[[UILabel  alloc] initWithFrame:CGRectMake(65,10, 15, 15)];
    _lblSaveHandbookCount.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    _lblSaveHandbookCount.textColor=[UIColor blackColor];
    
    _lblSaveHandbookCount.textAlignment=UITextAlignmentCenter;
    _lblSaveHandbookCount.text=@"0";
    [_btnSaved addSubview:_lblSaveHandbookCount];
    [_lblSaveHandbookCount.layer setMasksToBounds:YES];
    [_lblSaveHandbookCount.layer setCornerRadius:2];
    [_lblSaveHandbookCount.layer setBorderWidth:1.0];
    [_lblSaveHandbookCount.layer setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    
    UIButton* _btnSearchBar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_handbook_filter_off"] forState:UIControlStateNormal];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_handbook_filter_on"] forState:UIControlStateHighlighted];
    [_btnSearchBar addTarget:self action:@selector(filterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    backButtonView.bounds = CGRectOffset(backButtonView.bounds, -5, -0);
    [backButtonView addSubview:_btnSearchBar];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    params=[[NSMutableDictionary alloc] init];
    [params setValue:@"new" forKey:@"type"];
    
    CGRect footerRect = CGRectMake(0, 0, 320, 40);
    tableFooter = [[UILabel alloc] initWithFrame:footerRect];
    tableFooter.textColor = [UIColor grayColor];
    tableFooter.textAlignment=UITextAlignmentCenter;
    tableFooter.backgroundColor = [UIColor clearColor];
    tableFooter.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    tableFooter.hidden=YES;
    self.tableView.tableFooterView = tableFooter;
    
    [self postToGetManual];
    
    __weak ManualVC *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        NSLog(@"weakSelf.tableView.infiniteScrollingView.state=%d",weakSelf.tableView.infiniteScrollingView.state);
        if (weakSelf.tableView.infiniteScrollingView.state!=SVInfiniteScrollingStateLoading) {
            weakSelf.tableView.showsInfiniteScrolling=YES;
            offset=0;
            [weakSelf postToGetManual];
        }
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"weakSelf.tableView.pullToRefreshView.state=%d",weakSelf.tableView.pullToRefreshView.state);
        if (weakSelf.tableView.pullToRefreshView.state!=SVInfiniteScrollingStateLoading) {
            [weakSelf postToGetManual];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnRecently:nil];
    [self setBtnPopular:nil];
    [self setBtnSaved:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark TVFilterVCDelegate
-(void)didClickedFilterButton{
    [self postToGetManual];
    
}

#pragma mark IBAction
-(void)filterButtonClicked{
    FilterVC* viewController = [[FilterVC alloc] initWithNibName:@"FilterVC" bundle:nil];
    viewController.params=params;
    [viewController setDelegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)recentlyButtonClicked:(UIButton*)sender {
    [_btnPopular setSelected:NO];
    [_btnSaved setSelected:NO];
    [sender setSelected:YES];
    
    [params setValue:@"new" forKey:@"type"];
    if (self.tableView.infiniteScrollingView.state!=SVInfiniteScrollingStateLoading) {
        self.tableView.showsInfiniteScrolling=YES;
        offset=0;
        [self postToGetManual];
    }
}

- (IBAction)popularButtonClicked:(UIButton*)sender {
    [_btnRecently setSelected:NO];
    [_btnSaved setSelected:NO];
    [sender setSelected:YES];
    
    [params setValue:@"view" forKey:@"type"];
    if (self.tableView.infiniteScrollingView.state!=SVInfiniteScrollingStateLoading) {
        self.tableView.showsInfiniteScrolling=YES;
        offset=0;
        [self postToGetManual];
    }
}

- (IBAction)savedButtonClicked:(UIButton*)sender {
    [_btnRecently setSelected:NO];
    [_btnPopular setSelected:NO];
    [sender setSelected:YES];
    
    [params setValue:@"user" forKey:@"type"];
    [params setValue:[GlobalDataUser sharedAccountClient].user.userId forKey:@"user_id"];
    if (self.tableView.infiniteScrollingView.state!=SVInfiniteScrollingStateLoading) {
        self.tableView.showsInfiniteScrolling=YES;
        offset=0;
        [self postToGetManual];
    }
}

-(void)saveButtonClicked:(UIButton*)sender{
    if ([GlobalDataUser sharedAccountClient].isLogin) {
        
        TVManual* manual=_manualArr[sender.tag];
        NSDictionary *paramsHandBook = [NSDictionary dictionaryWithObjectsAndKeys:
                                        manual.manualID,@"handbook_id" ,
                                        [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                                        nil];
        
        [[TVNetworkingClient sharedClient] postPath:@"handbook/userSaveHandbook" parameters:paramsHandBook success:^(AFHTTPRequestOperation *operation, id JSON) {
            sender.userInteractionEnabled=NO;
            [sender setTitle:@"Đã lưu" forState:UIControlStateNormal];
            [TSMessage showNotificationInViewController:self
                                              withTitle:@"Lưu cẩm nang thành công"
                                            withMessage:nil
                                               withType:TSMessageNotificationTypeSuccess];
            
            [self dismissModalViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [TSMessage showNotificationInViewController:self
                                              withTitle:@"Lưu cẩm nang thất bại thất bại"
                                            withMessage:nil
                                               withType:TSMessageNotificationTypeError];
        }];
    }else{
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Bạn muốn login ?"];
        
        [alertView addButtonWithTitle:@"Login"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  
                                  LoginVC* loginVC=nil;
                                  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                                      loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
                                  } else {
                                      loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
                                  }
                                  
                                  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
                                  [self presentModalViewController:navController animated:YES];
                                  [loginVC goWithDidLogin:^{
                                      if ([self respondsToSelector:@selector(saveButtonClicked:)]) {
                                          [self performSelector:@selector(saveButtonClicked:) withObject:sender afterDelay:1];
                                      }
                                      
                                  } thenLoginFail:^{
                                      [TSMessage showNotificationInViewController:self
                                                                        withTitle:@"Có lỗi khi đăng nhập!"
                                                                      withMessage:nil
                                                                         withType:TSMessageNotificationTypeWarning];
                                  }];
                                  
                                  
                              }];
        [alertView addButtonWithTitle:@"Cancel"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  NSLog(@"Cancel Clicked");
                              }];
        [alertView show];
    }
}

-(void)detailButtonClicked:(UIButton*)sender{
//    NSLog(@"sender.tag=%d",sender.tag);
    TVManual* manual=_manualArr[sender.tag];
    DetailManualVC* detailManual=[[DetailManualVC alloc] initWithNibName:@"DetailManualVC" bundle:nil withManual:manual];
    
    [self.navigationController pushViewController:detailManual animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _manualArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TVManualCell* cell;
    
    NSString* strCellIdentifier=@"TVManualCell";
    cell = [tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    if (!cell) {
        cell = [[TVManualCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCellIdentifier];
        [cell.saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.saveButton.tag=indexPath.row;
    cell.detailButton.tag=indexPath.row;
    TVManual* manual=_manualArr[indexPath.row];
    [cell setManual:manual];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TVManual* manual=_manualArr[indexPath.row];
    return 270 + [TVManualCell sizeExpectedWithText:manual.title andDesc:manual.desc];
}
@end
