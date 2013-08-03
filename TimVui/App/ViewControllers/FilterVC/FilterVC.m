//
//  FilterVC.m
//  Anuong
//
//  Created by Hoang The Hung on 8/3/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "FilterVC.h"
#import "TVNetworkingClient.h"
#import "NSDictionary+Extensions.h"
#import "FilterCell.h"
#import <QuartzCore/QuartzCore.h>
@interface FilterVC ()

@end

@implementation FilterVC

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
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
    // Do any additional setup after loading the view from its nib.
    [[TVNetworkingClient sharedClient] getPath:@"handbook/getFilters" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSDictionary* dic=[JSON safeDictForKey:@"data"];
        _cityArr=[[dic safeDictForKey:@"cities"] allValues];
        _topicArr=[[dic safeDictForKey:@"cats"] allValues];
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
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) 
        return [_cityArr count];
    else 
        return [_topicArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

	NSString *headerText;
	if (section==0)
        headerText=@"Địa phương";
    else
        headerText=@"Chủ đề";
    
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view setBackgroundColor:[UIColor clearColor]];
    UIView* bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 010, 320, 30)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:bgView];
//    CALayer* l=[view layer];
//    [l setMasksToBounds:YES];
//    [l setCornerRadius:1];
//    // You can even add a border
//    [l setBorderWidth:1.0];
//    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(bgView.bounds, 3.0f, 5.0f)];
    textLabel.text = headerText;
    textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(12)];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [bgView addSubview:textLabel];
	return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* strCellIdentifier=@"FilterCell";
    FilterCell*cell = [tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    if (!cell) {
        cell = [[FilterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text=[[_cityArr objectAtIndex:indexPath.row] safeStringForKey:@"name"];
            break;
        case 1:
            cell.textLabel.text=[[_topicArr objectAtIndex:indexPath.row] safeStringForKey:@"name"];
            break;
        default:
            break;
    }
    
    return cell;
}

@end
