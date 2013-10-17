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
#import "Utilities.h"

@interface FilterVC ()
{

}
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

-(void)doneButtonClicked{
    
    NSMutableArray* arrTopic=[[NSMutableArray alloc] init];
    NSMutableArray* arrCity=[[NSMutableArray alloc] init];

    for (TVFilter* filter in _cityArr) {
        if (filter.isCheck) {
            [arrCity addObject:filter.TVFilteID];
        }
    }
    
    for (TVFilter* filter in _topicArr) {
        if (filter.isCheck) {
            [arrTopic addObject:filter.TVFilteID];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [_params setObject:arrTopic forKey:@"handbook_cat_id"];
    
    [_params setObject:arrCity forKey:@"city_id"];
    if ([_delegate respondsToSelector:@selector(didClickedFilterButton)]) {
        [_delegate didClickedFilterButton];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];

    self.navigationItem.rightBarButtonItem=[self barButtonWithTitle:@"Lọc"];

    UIView* bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 416-44, 320, 44)];
    [bgView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:bgView];
    
    UIButton* _detailButton = [[UIButton alloc] initWithFrame:CGRectMake(5+5, 5, 300, 34)];
    [_detailButton  setTitle:@"LỌC LẠI DANH SÁCH" forState:UIControlStateNormal];
    [_detailButton setBackgroundImage:[Utilities imageFromColor:kCyanGreenColor] forState:UIControlStateNormal];
    
    [_detailButton setBackgroundImage:[Utilities imageFromColor:kPaleCyanGreenColor] forState:UIControlStateSelected];
    [_detailButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_detailButton];
    bgView.autoresizingMask           = UIViewAutoresizingFlexibleTopMargin;
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
    // Do any additional setup after loading the view from its nib.
    [[TVNetworkingClient sharedClient] getPath:@"handbook/getFilters" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSDictionary* dic=[JSON safeDictForKey:@"data"];
        
        NSMutableArray* temp=[[NSMutableArray alloc] init];
        for (NSDictionary *dicRow in [[dic safeDictForKey:@"cities"] allValues]) {
            [temp addObject:[[TVFilter alloc] initWithDic:dicRow isChildren:NO]];
        }
        
        _cityArr=temp;
        temp=[[NSMutableArray alloc] init];
        for (NSDictionary *dicRow in [[dic safeDictForKey:@"cats"] allValues]) {
            NSArray* arrRow=[dicRow safeArrayForKey:@"children"];
            [temp addObject:[[TVFilter alloc] initWithDic:dicRow isChildren:NO]];
            if (arrRow) {
                for (NSDictionary* childrenDic in arrRow) {
                    [temp addObject:[[TVFilter alloc] initWithDic:childrenDic isChildren:YES]];
                }
            }
        }
        _topicArr=temp;
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
    TVFilter* dic=nil;
    switch (indexPath.section) {
        
        case 0:
            dic=[_cityArr objectAtIndex:indexPath.row] ;
            cell.textLabel.text=dic.name;
            break;
            
        case 1:
            dic=[_topicArr objectAtIndex:indexPath.row] ;
            cell.textLabel.text=dic.name;
            break;
            
        default:
            break;
            
    }

    if (dic.isCheck){
        cell.accessoryView.hidden=NO;
        
    }else{
        cell.accessoryView.hidden=YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TVFilter* dic=nil;
    FilterCell* cell=(FilterCell*)[tableView cellForRowAtIndexPath:indexPath];

    switch (indexPath.section) { 
        case 0:
            dic=[_cityArr objectAtIndex:indexPath.row] ;

            break;
            
        case 1:
            dic=[_topicArr objectAtIndex:indexPath.row] ;

            break;
            
        default:
            break;
            
    }
    if (dic.isCheck){
        dic.isCheck=NO;
        cell.accessoryView.hidden=YES;
    }else{
        dic.isCheck=YES;
        cell.accessoryView.hidden=NO;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
