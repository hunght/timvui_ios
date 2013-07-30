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

- (IBAction)recentlyButtonClicked:(id)sender {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"new",@"type" ,
                            nil];
    [self postToGetManualWithType:params];
}

- (IBAction)popularButtonClicked:(id)sender {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"view",@"type",
                            nil];
    [self postToGetManualWithType:params];
}

- (IBAction)savedButtonClicked:(id)sender {
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
    }
    
    TVManual* manual=_manualArr[indexPath.row];
    cell.lblTitle.text=manual.title;
    [cell.lblTitle sizeToFit];
    
    int height=cell.lblTitle.frame.origin.y+cell.lblTitle.frame.size.height;
    CGRect frame=cell.imgView.frame;
    frame.origin.y=height+5;
    [cell.imgView setFrame:frame];
    [cell.imgView setImageWithURL:[NSURL URLWithString:manual.images]];
    
    height=cell.imgView.frame.origin.y+cell.imgView.frame.size.height;
    frame=cell.webView.frame;
    frame.origin.y=height+5;
    [cell.webView setFrame:frame];
    
    [cell.webView loadHTMLString:manual.content baseURL:nil];
    [cell.webView setDelegate:self];
    
    height=cell.webView.frame.origin.y+cell.webView.frame.size.height;
    frame=cell.saveButton.frame;
    frame.origin.y=height+5;
    cell.saveButton.frame=frame;
    
    frame=cell.detailButton.frame;
    frame.origin.y=height+5;
    cell.detailButton.frame=frame;
    
    cell.saveButton.tag=indexPath.row;
    cell.detailButton.tag=indexPath.row;
    
    cell.lblTags.text=@"adfjklasfghklds";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 380;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    
}

@end
