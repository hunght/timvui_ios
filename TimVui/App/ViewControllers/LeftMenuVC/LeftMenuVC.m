//
//  DropDownExample.m
//  VPPLibraries
//
//  Created by Víctor on 13/12/11.
//  Copyright (c) 2011 Víctor Pena Placer. All rights reserved.
//

#import "LeftMenuVC.h"
#import "GHMenuCell.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalDataUser.h"
#import "LoginVC.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define kNumberOfSections 3

enum {
    kSection1UserAccount = 0,
    kSection2Services,
    kSection3Setting
};


// including the dropdown cell !!
/* set to 3 if you want to see how it behaves 
 when having more cells in the same section 
 */
#define kNumberOfRowsInSection1 2 

enum {
    kS1Row0 = 0,
    kS1Row1
};
enum {
    kS1AccountRecentlyAction = 0,
    kS1AccountInfoUser,
    kS1AccountReceivedCoupon,
    kS1AccountInteresting,
    kS1AccountRecentlyView
};

/* set to 2 if you want to see how it behaves 
 when having more cells in the same section 
 */

#define kNumberOfRowsInSection2 4
enum {
    kS2Home = 0,
    kS2Promotion,
    kS2Handbook,
    kS2GoingEven
};

#define kNumberOfRowsInSection3 3
enum {
    kS3Row0 = 0,
    kS3Row1,
    kS3Row2
};
@implementation LeftMenuVC

- (void)checkAndRefreshTableviewWhenUserLoginOrLogout
{
    // Custom initialization
    NSMutableArray *elts=nil;
    if ([GlobalDataUser sharedClient].isLogin) {
        elts = [NSMutableArray array];
        for (int i = 1; i <= 4; i++) {
            // just some mock elements
            VPPDropDownElement *e = [[VPPDropDownElement alloc] initWithTitle:[NSString stringWithFormat:@"Element %d",i] andObject:[NSNumber numberWithInt:i]];
            [elts addObject:e];
        }
    }
    _dropDownCustom = [[VPPDropDown alloc] initWithTitle:@"Custom Combo" 
                                                    type:VPPDropDownTypeCustom 
                                               tableView:self.tableView 
                                               indexPath:[NSIndexPath indexPathForRow:kS1Row0 inSection:kSection1UserAccount]
                                                elements:elts
                                                delegate:self];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self checkAndRefreshTableviewWhenUserLoginOrLogout];
        _headers=[[NSArray alloc] initWithObjects:@"Tài khoản",@"Từ Anuong.net",@"Cài đặt", nil];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        [self.view setBackgroundColor:[UIColor clearColor]];
        UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_table_menu_bg"]];
        self.tableView.backgroundColor = bgColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *fonts = [UIFont fontNamesForFamilyName:@"Arial"];
    
    for(NSString *string in fonts){
        NSLog(@"%@", string);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rows = [VPPDropDown tableView:tableView numberOfExpandedRowsInSection:section];
    switch (section) {

        case kSection1UserAccount:
            rows += kNumberOfRowsInSection1;
            break;
        case kSection2Services:
            rows += kNumberOfRowsInSection2;
            break;
        case kSection3Setting:
            rows += kNumberOfRowsInSection3;
            break;
            
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    GHMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    
    // Configure the cell...
    cell.textLabel.text = nil;

    if ([VPPDropDown tableView:tableView dropdownsContainIndexPath:indexPath]) {
        return [VPPDropDown tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    // first check if any dropdown contains the requested cell
    int row = indexPath.row - [VPPDropDown tableView:tableView numberOfExpandedRowsInSection:indexPath.section];
    switch (indexPath.section) {
        case kSection1UserAccount:
            switch (row) {
                case kS1Row1:
                    if ([GlobalDataUser sharedClient].isLogin) 
                        cell.textLabel.text = @"Cài đặt tài khoản";
                    else
                        cell.textLabel.text = @"Xem gần đây";
                    
                    break;
            }
            break;
        case kSection2Services:
            switch (row) {
                case kS1Row0:
                    cell.textLabel.text = @"This is an independent cell";
                    break;
            }
            break;

    }
        
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (_headers[section] == [NSNull null]) ? 0.0f : 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSObject *headerText = _headers[section];
	UIView *headerView = nil;
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 44.0f)];
		headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_header_session"]];
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 3.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(17)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		textLabel.textColor = [UIColor colorWithRed:(236.0f/255.0f) green:(234.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f];
		textLabel.backgroundColor = [UIColor clearColor];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(219.0f/255.0f) green:(219.0f/255.0f) blue:(219.0f/255.0f) alpha:1.0f];
		[textLabel.superview addSubview:topLine];
		
		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine2.backgroundColor = [UIColor whiteColor];
		[textLabel.superview addSubview:topLine2];
		[headerView addSubview:textLabel];
	}
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    // first check if any dropdown contains the requested cell
    if ([VPPDropDown tableView:tableView dropdownsContainIndexPath:indexPath]) {
        [VPPDropDown tableView:tableView didSelectRowAtIndexPath:indexPath];
        if ([GlobalDataUser sharedClient].isLogin==NO&&indexPath.section==kSection1UserAccount && indexPath.row==kS1Row0) {
            LoginVC* loginVC=nil;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
            } else {
                loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
            }
            UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            [self presentModalViewController:navController animated:YES];
            [loginVC setDelegate:self];
            _globalIndexPath=indexPath;
        }
        return;
    }
    
    int row = indexPath.row - [VPPDropDown tableView:tableView numberOfExpandedRowsInSection:indexPath.section];
    UIAlertView *av;
    switch (indexPath.section) {
        case kSection2Services:
            switch (row) {
                case kS1Row1:
                    av = [[UIAlertView alloc] initWithTitle:@"Cell selected" message:@"The independent cell 1 has been selected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case kSection1UserAccount:
            switch (row) {
                case kS1Row1:
                    av = [[UIAlertView alloc] initWithTitle:@"Cell selected" message:@"The independent cell 2 has been selected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
                    break;
                    
                default:
                    break;
            }
            
            break;
    }
    
}
#pragma mark - LoginVCDelegate
-(void)userFacebookDidLogin{
    [self checkAndRefreshTableviewWhenUserLoginOrLogout];
    [self.tableView reloadData];
    if ([VPPDropDown tableView:self.tableView dropdownsContainIndexPath:_globalIndexPath]) {
        [VPPDropDown tableView:self.tableView didSelectRowAtIndexPath:_globalIndexPath];
    }
    
    
}

#pragma mark - VPPDropDownDelegate

- (void) dropDown:(VPPDropDown *)dropDown elementSelected:(VPPDropDownElement *)element atGlobalIndexPath:(NSIndexPath *)indexPath {
    
    if (dropDown == _dropDownCustom) {
        //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (UITableViewCell *) dropDown:(VPPDropDown *)dropDown rootCellAtGlobalIndexPath:(NSIndexPath *)globalIndexPath {
    static NSString *cellIdentifier = @"GlobalDropDownCell";
    
    GHMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] ;
    }
    
    if ([GlobalDataUser sharedClient].isLogin){
        cell.textLabel.text = [GlobalDataUser sharedClient].username;
        [cell.imageView setImageWithURL:[GlobalDataUser sharedClient].avatarImageURL placeholderImage:[UIImage imageNamed:@"user"]];
    }
        
    else{
        cell.textLabel.text = @"Đăng nhập";
        [cell.imageView setImage:[UIImage imageNamed:@"user"]];
    }
    
    return cell;
}

- (UITableViewCell *) dropDown:(VPPDropDown *)dropDown cellForElement:(VPPDropDownElement *)element atGlobalIndexPath:(NSIndexPath *)globalIndexPath {
    static NSString *cellIdentifier = @"CustomDropDownCell";

    GHMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] ;
    }
    int row=globalIndexPath.row;
    switch (row) {
        case kS1AccountRecentlyAction:
            cell.textLabel.text = @"Hoạt động gần đây";
            break;
        case kS1AccountInfoUser:
            cell.textLabel.text = @"Thông tin cá nhân";
            break;
        case kS1AccountReceivedCoupon:
            cell.textLabel.text = @"Coupon đã nhận";
            break;
        case kS1AccountInteresting:
            cell.textLabel.text = @"Đang quan tâm";
            break;
        case kS1AccountRecentlyView:
            cell.textLabel.text = @"Xem gần đây";
            break;
        default:
            break;
    }
    
    
    return cell;
}


- (CGFloat) dropDown:(VPPDropDown *)dropDown heightForElement:(VPPDropDownElement *)element atIndexPath:(NSIndexPath *)indexPath {
    float height = dropDown.tableView.rowHeight;
    
    return height + indexPath.row * 10;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_globalIndexPath != nil) {
        [self.tableView deselectRowAtIndexPath:_globalIndexPath animated:YES];
        _globalIndexPath = nil;
    }
}

@end
