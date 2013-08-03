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
#import "NSDate+Helper.h"
#import "Utilities.h"
#import "FilterVC.h"
@interface ManualVC ()

@end

@implementation ManualVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _manualArr=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)postToGetManualWithType:(NSDictionary *)params
{
    NSLog(@"param=%@",params);
    [[TVNetworkingClient sharedClient] postPath:@"handbook/getHandbooks" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        [_manualArr removeAllObjects];
        for (NSDictionary* dic in [[JSON valueForKey:@"data"] allValues]) {
            TVManual* munual=[[TVManual alloc] initWithDict:dic];
            [_manualArr addObject:munual];
        }

        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
    
    [_btnRecently setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(245/255.0f) green:(77/255.0f) blue:(44/255.0f) alpha:1.0f]] forState:UIControlStateNormal];
    [_btnPopular setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(245/255.0f) green:(77/255.0f) blue:(44/255.0f) alpha:1.0f]] forState:UIControlStateNormal];
    [_btnSaved setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(245/255.0f) green:(77/255.0f) blue:(44/255.0f) alpha:1.0f]] forState:UIControlStateNormal];
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
    
    UIButton* _btnSearchBar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 43)];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_handbook_filter_off"] forState:UIControlStateNormal];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_handbook_filter_on"] forState:UIControlStateHighlighted];
    [_btnSearchBar addTarget:self action:@selector(filterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 43)];
    backButtonView.bounds = CGRectOffset(backButtonView.bounds, -5, -0);
    [backButtonView addSubview:_btnSearchBar];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    NSString* strType=@"view";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strType,@"type" ,
                            nil];
    [self postToGetManualWithType:params];
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

#pragma mark IBAction
-(void)filterButtonClicked{
    FilterVC* viewController = [[FilterVC alloc] initWithNibName:@"FilterVC" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)recentlyButtonClicked:(UIButton*)sender {
    [_btnPopular setSelected:NO];
    [_btnSaved setSelected:NO];
    [sender setSelected:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"new",@"type" ,
                            nil];
    
    [self postToGetManualWithType:params];
}

- (IBAction)popularButtonClicked:(UIButton*)sender {
    [_btnRecently setSelected:NO];
    [_btnSaved setSelected:NO];
    [sender setSelected:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"view",@"type",
                            nil];
    [self postToGetManualWithType:params];
}

- (IBAction)savedButtonClicked:(UIButton*)sender {
    [_btnRecently setSelected:NO];
    [_btnPopular setSelected:NO];
    [sender setSelected:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"user",@"type",
                            [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                            nil];
    [self postToGetManualWithType:params];
}

-(void)saveButtonClicked:(UIButton*)sender{
    TVManual* manual=_manualArr[sender.tag];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            manual.manualID,@"handbook_id" ,
                            [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                            nil];
    [[TVNetworkingClient sharedClient] postPath:@"handbook/userSaveHandbook" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
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
}

-(void)detailButtonClicked:(UIButton*)sender{
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
        cell.saveButton.tag=indexPath.row;
        cell.detailButton.tag=indexPath.row;
    }
    
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
