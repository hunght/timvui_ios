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
#import "TVAppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ECSlidingViewController.h"
#import "MainVC.h"
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
    if ([GlobalDataUser sharedAccountClient].isLogin) {
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
    [self performSelector:@selector(openViewController:) withObject:[[MainVC alloc] initWithStyle:UITableViewStylePlain] afterDelay:.0];
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
                    if ([GlobalDataUser sharedAccountClient].isLogin) 
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
	UIViewController *viewController = nil;
    
    // first check if any dropdown contains the requested cell
    if ([VPPDropDown tableView:tableView dropdownsContainIndexPath:indexPath]) {
        [VPPDropDown tableView:tableView didSelectRowAtIndexPath:indexPath];
        if ([GlobalDataUser sharedAccountClient].isLogin==NO&&indexPath.section==kSection1UserAccount && indexPath.row==kS1Row0) {
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
    }else{
        
        int row = indexPath.row - [VPPDropDown tableView:tableView numberOfExpandedRowsInSection:indexPath.section];
        UIAlertView *av;
        switch (indexPath.section) {
            case kSection2Services:
                switch (row) {
                    case kS1Row0:
                        viewController = [[MainVC alloc] initWithStyle:UITableViewStylePlain];
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
        // Maybe push a controller
        if (viewController) {
            [self openViewController:viewController];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark Helper

- (void)toggleTopView {
    self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
    if (self.slidingViewController.underLeftShowing) {
        // actually this does not get called when the top view screenshot is enabled
        // because the screenshot intercepts the touches on the toggle button
        [self.slidingViewController resetTopView];
    } else {
        [self.slidingViewController anchorTopViewTo:ECRight];
    }
}



- (UIBarButtonItem *)toggleBarButtonItem {
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-off"] forState:UIControlStateHighlighted];
    //    [backButton addTarget:self.viewDeckController action:@selector(toggleDownLeftView) forControlEvents:UIControlEventTouchDown];
    [backButton addTarget:self action:@selector(toggleTopView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    item.accessibilityLabel = NSLocalizedString(@"Menu", nil);
    item.accessibilityHint = NSLocalizedString(@"Double-tap to reveal menu on the left. If you need to close the menu without choosing its item, find the menu button in top-right corner (slightly to the left) and double-tap it again.", nil);
    return item;
}


// clean up the old state and push the given controller wrapped in a navigation controller.
// in case the given view controller is already a navigation controller it used it directly.
- (void)openViewController:(UIViewController *)viewController {
    // unset the current navigation controller
	UINavigationController *currentController = (UINavigationController *)self.slidingViewController.topViewController;
	[currentController popToRootViewControllerAnimated:NO];
	// prepare the new navigation controller
    UINavigationController *navController = nil;
    if ([viewController isKindOfClass:UINavigationController.class]) {
        navController = (UINavigationController *)viewController;
    } else {
        navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    }
    [navController.navigationBar dropShadowWithOffset:CGSizeMake(0, 5) radius:5 color:[UIColor blackColor] opacity:1];
	navController.view.layer.shadowOpacity = 0.8f;
	navController.view.layer.shadowRadius = 5;
	navController.view.layer.shadowColor = [UIColor blackColor].CGColor;
	// give the root view controller the toggle bar button item
    [(UIViewController *)navController.viewControllers[0] navigationItem].leftBarButtonItem = self.toggleBarButtonItem;
	// set the navigation controller as the new top view and bring it on
    [self.slidingViewController setTopViewController:navController];
	self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
    [navController.view addGestureRecognizer:self.slidingViewController.panGesture];
    [navController.navigationBar dropShadowWithOffset:CGSizeMake(0, 5) radius:5 color:[UIColor blackColor] opacity:1];
    [self.slidingViewController resetTopViewWithAnimations:nil onComplete:nil];
}


#pragma mark - FBLoginView delegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // Upon login, transition to the main UI by pushing it onto the navigation stack.
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error{
    NSString *alertMessage, *alertTitle;
    
    // Facebook SDK * error handling *
    // Error handling is an important part of providing a good user experience.
    // Since this sample uses the FBLoginView, this delegate will respond to
    // login failures, or other failures that have closed the session (such
    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
    // and [- requestPermissionAndPost] on `SCViewController` for further
    // error handling on other operations.
    
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // Facebook SDK * login flow *
    // It is important to always handle session closure because it can happen
    // externally; for example, if the current session's access token becomes
    // invalid. For this sample, we simply pop back to the landing page.
    // The delay is for the edge case where a session is immediately closed after
    // logging in and our navigation controller is still animating a push.
    [self performSelector:@selector(logOut) withObject:nil afterDelay:.5];
}

- (void)logOut {
    // TODO
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
    
    if ([GlobalDataUser sharedAccountClient].isLogin){
        cell.textLabel.text = [GlobalDataUser sharedAccountClient].username;
        [cell.imageView setImageWithURL:[GlobalDataUser sharedAccountClient].avatarImageURL placeholderImage:[UIImage imageNamed:@"user"]];
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
