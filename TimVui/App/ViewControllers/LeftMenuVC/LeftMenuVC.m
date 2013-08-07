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
#import "MapTableViewController.h"
#import "MyNavigationController.h"
#import "TVCameraVC.h"
#import "SkinPickerTableVC.h"
#import "CommentVC.h"
#import "BlockAlertView.h"
#import "RecentlyBranchListVC.h"
#import "ManualVC.h"
#import <SVProgressHUD.h>
#import "TVMenuUserCell.h"

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
#define kNumberOfRowsInSection1 7


enum {
    kS1AccountInfoUser=0,
    kS1AccountRecentlyView,
    kS1AccountReceivedCoupon,
    kS1AccountSetting
};
enum {
    kS1InfoUser=0,
    kS1RecentlyView,
    kS1ReceivedCoupon,
    kS1Interesting,
    kS1Setting,
    kS1History,
    kS1UpdateAccount
    
};

/* set to 2 if you want to see how it behaves 
 when having more cells in the same section 
 */

#define kNumberOfRowsInSection2 4
enum {
    kS2Home = 0,
    kS2Coupon,
    kS2GoingEven,
    kS2Handbook
};

#define kNumberOfRowsInSection3 6
enum {
    kS3Row0 = 0,
    kS3Row1,
    kS3Row2,
    kS3Row3,
    kS3Row4,
    kS3Row5
};
@implementation LeftMenuVC

- (void)checkAndRefreshTableviewWhenUserLoginOrLogout
{
    if (_lastStatusLogin==[GlobalDataUser sharedAccountClient].isLogin) {
        return;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self checkAndRefreshTableviewWhenUserLoginOrLogout];
        _headers=[[NSArray alloc] initWithObjects:@"Tài khoản",@"Từ Anuong.net",@"Cài đặt", nil];
        
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
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
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
    [self refreshTableViewDropdown];
    if ([SVProgressHUD isVisible])
        [SVProgressHUD dismiss];
    
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

-(void)showLoginScreenWhenUserNotLogin:(UINavigationController*)nav{
    LoginVC* loginVC=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
    } else {
        loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
    }
    loginVC.isPushNaviYES=YES;
    [nav pushViewController:loginVC animated:YES];
    [loginVC goWithDidLogin:^{
        
    } thenLoginFail:^{
        
    }];
}

#pragma mark - Camera Comment Action
- (void)showCameraActionWithLocation:(TVBranches*)branches
{
    TVCameraVC* tvCameraVC=[[TVCameraVC alloc] initWithNibName:@"TVCameraVC" bundle:nil];
    LocationTableVC* tableVC=[[LocationTableVC   alloc] initWithStyle:UITableViewStylePlain];
    tableVC.branches=branches;
    [tableVC setDelegate:tvCameraVC];
    SkinPickerTableVC* skinVC=[[SkinPickerTableVC   alloc] initWithStyle:UITableViewStylePlain];
    [skinVC setDelegate:tvCameraVC];
    UINavigationController* navController =navController = [[MyNavigationController alloc] initWithRootViewController:tvCameraVC];
    
    ECSlidingViewController *_slidingViewController=[[ECSlidingViewController alloc] init];
    _slidingViewController.topViewController=navController;
    _slidingViewController.underLeftViewController = tableVC;
    _slidingViewController.anchorRightRevealAmount = 320-44;
    _slidingViewController.underRightViewController = skinVC;
    _slidingViewController.anchorLeftRevealAmount = 320-44;
    
    [navController.view addGestureRecognizer:_slidingViewController.panGesture];
    [self presentModalViewController:_slidingViewController animated:YES];
    tvCameraVC.slidingViewController=_slidingViewController;
}

- (void)showCameraActionWithBranch:(TVBranch*)branch
{
    TVCameraVC* tvCameraVC=[[TVCameraVC alloc] initWithNibName:@"TVCameraVC" bundle:nil];
    SkinPickerTableVC* skinVC=[[SkinPickerTableVC   alloc] initWithStyle:UITableViewStylePlain];
    [skinVC setDelegate:tvCameraVC];
    UINavigationController* navController =navController = [[MyNavigationController alloc] initWithRootViewController:tvCameraVC];
    tvCameraVC.branch=branch;
    ECSlidingViewController *_slidingViewController=[[ECSlidingViewController alloc] init];
    _slidingViewController.topViewController=navController;
    _slidingViewController.underRightViewController = skinVC;
    _slidingViewController.anchorLeftRevealAmount = 320-44;
    
    [navController.view addGestureRecognizer:_slidingViewController.panGesture];
    [self presentModalViewController:_slidingViewController animated:YES];
    tvCameraVC.slidingViewController=_slidingViewController;
}

- (void)showCommentActionWithBranch:(TVBranch*)branch
{
    CommentVC* commentVC=[[CommentVC alloc] initWithNibName:@"CommentVC" bundle:nil];
    UINavigationController* navController =navController = [[MyNavigationController alloc] initWithRootViewController:commentVC];
    commentVC.branch=branch;
    ECSlidingViewController *_slidingViewController=[[ECSlidingViewController alloc] init];
    _slidingViewController.topViewController=navController;
    
    [navController.view addGestureRecognizer:_slidingViewController.panGesture];
    [self presentModalViewController:_slidingViewController animated:YES];
    commentVC.slidingViewController=_slidingViewController;
}

- (void)showCommentActionWithBranches:(TVBranches*)branches
{
    CommentVC* commentVC=[[CommentVC alloc] initWithNibName:@"CommentVC" bundle:nil];
    LocationTableVC* tableVC=[[LocationTableVC   alloc] initWithStyle:UITableViewStylePlain];
    [tableVC setDelegate:commentVC];
    tableVC.branches=branches;
    UINavigationController* navController =navController = [[MyNavigationController alloc] initWithRootViewController:commentVC];
    
    ECSlidingViewController *_slidingViewController=[[ECSlidingViewController alloc] init];
    _slidingViewController.topViewController=navController;
    _slidingViewController.underLeftViewController = tableVC;
    _slidingViewController.anchorRightRevealAmount = 320-44;
    
    [navController.view addGestureRecognizer:_slidingViewController.panGesture];
    [self presentModalViewController:_slidingViewController animated:YES];
    commentVC.slidingViewController=_slidingViewController;
}

- (void)cameraButtonClickedWithNav:(UINavigationController*)nav andWithBranch:(TVBranch*)branch{
    if ([GlobalDataUser sharedAccountClient].isLogin)
        [self showCameraActionWithBranch:branch];
    else{
        LoginVC* loginVC=nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
        } else {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
        }
        loginVC.isPushNaviYES=YES;
        [nav pushViewController:loginVC animated:YES];
        [loginVC goWithDidLogin:^{
            [self showCommentActionWithBranch:branch];
        } thenLoginFail:^{
            
        }];
    }
}

- (void)cameraButtonClickedWithNav:(UINavigationController*)nav andWithBranches:(TVBranches*)branches
{
    if ([GlobalDataUser sharedAccountClient].isLogin)
        [self showCameraActionWithLocation:branches];
    else{
        LoginVC* loginVC=nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
        } else {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
        }
        loginVC.isPushNaviYES=YES;
        [nav pushViewController:loginVC animated:YES];
        [loginVC goWithDidLogin:^{
            [self showCameraActionWithLocation:branches];
        } thenLoginFail:^{
            
        }];
    }
}

- (void)commentButtonClickedWithNav:(UINavigationController*)nav andWithBranches:(TVBranches*)branches{
    if ([GlobalDataUser sharedAccountClient].isLogin)
        [self showCommentActionWithBranches:branches];
    else{
        LoginVC* loginVC=nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
        } else {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
        }
        loginVC.isPushNaviYES=YES;
        [nav pushViewController:loginVC animated:YES];
        [loginVC goWithDidLogin:^{
            [self showCommentActionWithBranches:branches];
        } thenLoginFail:^{
            
        }];
    }
}
- (void)commentButtonClickedWithNav:(UINavigationController*)nav andWithBranch:(TVBranch*)branch
{
    if ([GlobalDataUser sharedAccountClient].isLogin)
        [self showCommentActionWithBranch:branch];
    else{
        LoginVC* loginVC=nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
        } else {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
        }
        
        loginVC.isPushNaviYES=YES;
        [nav pushViewController:loginVC animated:YES];
        [loginVC goWithDidLogin:^{
            [self showCommentActionWithBranch:branch];
        } thenLoginFail:^{
            
        }];
    }
}
#pragma mark Helper

- (void)toggleTopView {
    //    self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
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
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-off"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-on"] forState:UIControlStateHighlighted];
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
    if ([currentController isKindOfClass:UINavigationController.class])
        [currentController popToRootViewControllerAnimated:NO];
	// prepare the new navigation controller
    UINavigationController *navController = nil;
    if ([viewController isKindOfClass:UINavigationController.class]) {
        navController = (UINavigationController *)viewController;
    } else {
        navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
    }
    [navController.navigationBar dropShadow];
	navController.view.layer.shadowOpacity = 0.8f;
	navController.view.layer.shadowRadius = 5;
	navController.view.layer.shadowColor = [UIColor blackColor].CGColor;
	// give the root view controller the toggle bar button item
    [(UIViewController *)navController.viewControllers[0] navigationItem].leftBarButtonItem = self.toggleBarButtonItem;
	// set the navigation controller as the new top view and bring it on
    [self.slidingViewController setTopViewController:navController];
	//self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
    self.slidingViewController.anchorRightPeekAmount=40.0f;
    [[(UIViewController *)navController.viewControllers[0] view] addGestureRecognizer:self.slidingViewController.panGesture];
    [navController.navigationBar dropShadow];
    [self.slidingViewController resetTopViewWithAnimations:nil onComplete:nil];
}


- (void)refreshTableViewDropdown
{
    [self checkAndRefreshTableviewWhenUserLoginOrLogout];
    
}

- (void)showLoginViewController
{
    LoginVC* loginVC=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
    } else {
        loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
    }
    
    UINavigationController* navController = [[MyNavigationController alloc] initWithRootViewController:loginVC];
    [self presentModalViewController:navController animated:YES];
    [loginVC goWithDidLogin:^{
        [self refreshTableViewDropdown];
        [self.tableView reloadData];
    } thenLoginFail:^{
        
    }];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0)return 2;
	return (_headers[section] == [NSNull null]) ? 0.0f : 34.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSObject *headerText = _headers[section];

	UIView *headerView = nil;
    if (section==0) {
        headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 3)];
        [headerView setBackgroundColor:[UIColor colorWithRed:(245/255.0f) green:(77/255.0f) blue:(44/255.0f) alpha:1.0f]];
        return  headerView;
    }
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 34.0f)];
		headerView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:1.0f];
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
    if (SharedAppDelegate.isLoadWhenConnectedYES==NO) {
        if ([SharedAppDelegate connected])
            [SharedAppDelegate loadWhenInternetConnected];
        return;
    }
    if (isNotTheFirstTimeOpenHomeYES==NO&&indexPath.section==kSection2Services&&indexPath.row==kS2Home) {
        isNotTheFirstTimeOpenHomeYES=YES;
        [self toggleTopView];
        lastIndexPath=indexPath;
        return;
    }
    if (lastIndexPath.section==indexPath.section&&lastIndexPath.row==indexPath.row) {
        if (lastIndexPath.section!=kSection1UserAccount) {
            [self toggleTopView];
            lastIndexPath=indexPath;
            return;
        }
    }
    lastIndexPath=indexPath;
	
    UIViewController *viewController = nil;
    int row = indexPath.row;
    switch (indexPath.section) {
        case kSection1UserAccount:
            if ([GlobalDataUser sharedAccountClient].isLogin){
                switch (row) {
                        
                    case kS1RecentlyView:
                        viewController = [[RecentlyBranchListVC alloc] initWithNibName:@"RecentlyBranchListVC" bundle:nil];
                        
                        break;
                    case kS1ReceivedCoupon:

                        break;
                    case kS1Interesting:

                        break;
                        
                    case kS1Setting:

                        break;
                    case kS1History:

                        break;
                    case kS1UpdateAccount:

                        break;
                        
                }
            }else
            {
                switch (row) {
                        
                    case kS1AccountRecentlyView:
                        viewController = [[RecentlyBranchListVC alloc] initWithNibName:@"RecentlyBranchListVC" bundle:nil];
                        break;
                    case kS1AccountReceivedCoupon:

                        break;
                    case kS1AccountSetting:

                        break;
                }
                break;
            case kSection2Services:
                switch (row) {
                    case kS2Home:
                        viewController = [[MapTableViewController alloc] initWithNibName:@"MapTableViewController" bundle:nil];
                        break;
                    case kS2Handbook:
                        viewController = [[ManualVC alloc] initWithNibName:@"ManualVC" bundle:nil];
                        break;
                    case kS2GoingEven:

                        break;
                    case kS2Coupon:

                        break;
                }
                break;
            case kSection3Setting:
                switch (row) {
                    case kS3Row0:

                        break;
                    case kS3Row1:

                        break;
                    case kS3Row2:

                        break;
                    case kS3Row3:

                        break;
                    case kS3Row4:

                        break;
                    case kS3Row5:
                    {
                        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Notify" message:@"Bạn muốn đăng xuất ?"];
                        [alert setCancelButtonWithTitle:@"Cancel" block:nil];
                        [alert setDestructiveButtonWithTitle:@"Logout!" block:^{
                            if ([GlobalDataUser sharedAccountClient].isLogin) {
                                [[FBSession activeSession] closeAndClearTokenInformation];
                                [[GlobalDataUser sharedAccountClient] userLogout];
                                [tableView reloadData];
                            }
                        }];
                        [alert show];
                    }
                        break;
                }
                break;
            }
    }
        // Maybe push a controller
    if (viewController) {
            [self openViewController:viewController];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) {
        return 70;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rows =0;
    switch (section) {
            
        case kSection1UserAccount:
            if ([GlobalDataUser sharedAccountClient].isLogin)
                rows += kNumberOfRowsInSection1;
            else
                rows += 4;
                break;
        case kSection2Services:
            rows += kNumberOfRowsInSection2;
            break;
        case kSection3Setting:
            if ([GlobalDataUser sharedAccountClient].isLogin)
                rows += kNumberOfRowsInSection3;
            else
                rows += kNumberOfRowsInSection3 -1;
            
            break;
            
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (indexPath.section==kSection1UserAccount&&indexPath.row==kS1InfoUser) {
         CellIdentifier = @"GlobalCustomDropDownCell";
        TVMenuUserCell *cellUser = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cellUser) {
            cellUser = [[TVMenuUserCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        }
        
        if ([GlobalDataUser sharedAccountClient].isLogin){           
            cellUser.textLabel.text = [GlobalDataUser sharedAccountClient].user.first_name;
            [cellUser.imgAvatar setImageWithURL:[[NSURL alloc] initWithString:[GlobalDataUser sharedAccountClient].user.avatar]  placeholderImage:[UIImage imageNamed:@"user"]];
        }else{
            cellUser.textLabel.text = @"Đăng nhập";
            [cellUser.imgAvatar setImage:[UIImage imageNamed:@"user"]];
        }
        
        return cellUser;
    }
    
    CellIdentifier = @"Cell";
    
    GHMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    
    // Configure the cell...
    cell.textLabel.text = nil;
    
    // first check if any dropdown contains the requested cell
    int row = indexPath.row;
    switch (indexPath.section) {
        case kSection1UserAccount:
            if ([GlobalDataUser sharedAccountClient].isLogin){
                switch (row) {

                    case kS1RecentlyView:
                            cell.imageView.image=[UIImage imageNamed:@"img_menu_user_option"];
                            cell.textLabel.text = @"Xem gần đây";
                            

                        break;
                    case kS1ReceivedCoupon:
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_coupon_received"];
                        cell.textLabel.text = @"Coupon đã nhận";
                        break;
                    case kS1Interesting:
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_interestedIn"];
                        cell.textLabel.text = @"Đang quan tâm";
                        break;
                        
                    case kS1Setting:
                            cell.imageView.image=[UIImage imageNamed:@"img_menu_user_option"];
                            cell.textLabel.text = @"Tuỳ chọn Gợi ý";

                        break;
                    case kS1History:
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_coupon_received"];
                        cell.textLabel.text = @"Lịch sử hoạt động";
                        break;
                    case kS1UpdateAccount:
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_interestedIn"];
                        cell.textLabel.text = @"Cập nhật tài khoản";
                        break;

                }
            }else
            {
                switch (row) {
                        
                    case kS1AccountRecentlyView:

                            cell.imageView.image=[UIImage imageNamed:@"img_menu_recently_views"];
                            cell.textLabel.text = @"Xem gần đây";
                        break;
                    case kS1AccountReceivedCoupon:
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_coupon_received"];
                        cell.textLabel.text = @"Coupon đã nhận";
                        break;
                    case kS1AccountSetting:
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_interestedIn"];
                        cell.textLabel.text = @"ĐTuỳ chọn Gợi ý";
                        break;
                }
            break;
        case kSection2Services:
            switch (row) {
                case kS2Home:
                    cell.textLabel.text = @"Trang chủ";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_home"];
                    break;
                case kS2Handbook:
                    cell.textLabel.text = @"Cẩm nang";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_handbook"];
                    break;
                case kS2GoingEven:
                    cell.textLabel.text = @"Sự kiện";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_event"];
                    break;
                case kS2Coupon:
                    cell.textLabel.text = @"Coupon";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_coupon"];
                    break;
            }
            break;
        case kSection3Setting:
            switch (row) {
                case kS3Row0:
                    cell.textLabel.text = @"Giới thiệu";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_intro"];
                    break;
                case kS3Row1:
                    cell.textLabel.text = @"Điều khoản sử dụng";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_termOfUse"];
                    break;
                case kS3Row2:
                    cell.textLabel.text = @"Facebook Page";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_fanPage"];
                    break;
                case kS3Row3:
                    cell.textLabel.text = @"Góp ý- Báo lỗi";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_reportError"];
                    break;
                case kS3Row4:
                    cell.textLabel.text = @"Mời bạn bè";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_inviteFriends"];
                    break;
                case kS3Row5:
                    if ([GlobalDataUser sharedAccountClient].isLogin) {
                        cell.textLabel.text = @"Đăng suất";
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_signOut"];
                    }
                    break;
            }
            break;
        }
    }
    return cell;
}

@end
