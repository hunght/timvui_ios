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
@interface ManualVC ()

@end

@interface TVManual : NSObject
@property(nonatomic,strong)NSString *manualID;
@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *content;

@end

@implementation TVManual

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1",@"username" ,
                            @"2",@"password",
                            nil];
    
    [[TVNetworkingClient sharedClient] postPath:@"handbook/getHandbooks" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        for (NSDictionary* dic in [[JSON valueForKey:@"data"] allValues]) {
            TVManual* munual=[[TVManual alloc] init];
            munual.title=[dic safeStringForKey:@"tilte"];
            munual.content=[dic safeStringForKey:@"content"];
            [_manualArr addObject:munual];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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

#pragma mark IBAction

- (IBAction)recentlyButtonClicked:(id)sender {
    
}

- (IBAction)popularButtonClicked:(id)sender {

}

- (IBAction)savedButtonClicked:(id)sender {

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
    }
    TVManual* manual=_manualArr[indexPath.row];
    cell.textLabel.text=manual.title;
    [cell.webView loadHTMLString:manual.content baseURL:nil];    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    
}

@end
