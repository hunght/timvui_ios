//
//  AppDelegate.m
//  TimVui
//
//  Created by Hoang The Hung on 3/22/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "TVNetworkingClient.h"
#import "ECSlidingViewController.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import <GoogleMaps/GoogleMaps.h>
#import "WelcomeVC.h"
#import "TSMessage.h"
#import "GlobalDataUser.h"
#import "NSDate-Utilities.h"
#import <JSONKit.h>
#import "BranchProfileVC.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "RecentlyBranchListVC.h"
#import "TVNotification.h"
#import "TVCoupons.h"
#import "MyNavigationController.h"
#import "NSDictionary+Extensions.h"

@interface TVAppDelegate () <UIApplicationDelegate>
@property(nonatomic,strong)ECSlidingViewController *slidingViewController;
@end


@implementation TVAppDelegate
@synthesize window = _window;
@synthesize menuVC = _leftController;
@synthesize tracker=_tracker;

- (void)setupGoogleAnalytics
{
    // Optional: automatically track uncaught exceptions with Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = NO;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 120;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = NO;
    // Create tracker instance.
    _tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    [GAI sharedInstance].defaultTracker = _tracker;
}

- (void)setupAFNetworking
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if (!url) {  return NO; }
    
    NSString *URLString = [url absoluteString];
    NSLog(@"URLString ==== %@",URLString);
    // Facebook SDK * login flow *
    // Attempt to handle URLs to complete any auth (e.g., SSO) flow.
    if ([[FBSession activeSession] handleOpenURL:url]) {
        return YES;
    } else {
        // Facebook SDK * App Linking *
        // For simplicity, this sample will ignore the link if the session is already
        // open but a more advanced app could support features like user switching.
        // Otherwise extract the app link data from the url and open a new active session from it.
        NSString *appID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"];
        FBAccessTokenData *appLinkToken = [FBAccessTokenData createTokenFromFacebookURL:url
                                                                                  appID:appID
                                                                        urlSchemeSuffix:nil];
        if (appLinkToken) {
            if ([FBSession activeSession].isOpen) {
                NSLog(@"INFO: Ignoring app link because current session is open.");
            } else {
                [self handleAppLink:appLinkToken];
                return YES;
            }
        }
    }
    return NO;
}

// Helper method to wrap logic for handling app links.
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  NSLog(@"%@",error);
                                  //[self.loginViewController loginView:nil handleError:error];
                              }
                          }];
}

-(void)showNotificationWithBranch:(TVBranch*)branch{
    TVNotification* notificationView=[[TVNotification alloc] initWithView:_slidingViewController.topViewController.view withTitle:branch.name  withDistance:branch.name  goWithClickView:^(){

        BranchProfileVC* branchProfileVC=[[BranchProfileVC alloc] initWithNibName:@"BranchProfileVC" bundle:nil];
        branchProfileVC.branch=branch;
        UINavigationController* navController = [[MyNavigationController alloc] initWithRootViewController:branchProfileVC];
        branchProfileVC.isPresentationYES=YES;
        //        specBranchVC.coupon=branch.coupons.items[0];
        [_slidingViewController.topViewController presentModalViewController:navController animated:YES];
    }];
    [notificationView openButtonClicked:nil];
}

-(void)showNotificationAboutNearlessBranch:(TVBranch*)branch
{
    TVNotification* notificationView=[[TVNotification alloc] initWithView:_slidingViewController.topViewController.view withTitle:branch.name goWithCamera:^{
        [SharedAppDelegate.menuVC cameraButtonClickedWithNav:_slidingViewController.modalViewController.navigationController andWithBranch:branch];
    } withComment:^{
        [SharedAppDelegate.menuVC commentButtonClickedWithNav:_slidingViewController.navigationController andWithBranch:branch];
    }];
    
    [notificationView openButtonClicked:nil];
}


#pragma mark Helpers
// NSURLCache seems to have a problem with Cache-Control="private" headers.
// Most resources of GitHubs API use this header and the response gets cached
// longer than the interval given by GitHub (in most cases 60 seconds).
// This way we lose caching, but its still better than unexpected results.
- (void)deactivateURLCache {
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
}

- (void)getNewDataParamsFromServer:(NSString*)strPath withDic:(NSDictionary*)myDic forKey:(NSString*)key
{
    [[TVNetworkingClient sharedClient] getPath:strPath parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableDictionary* dic=[[NSMutableDictionary alloc] initWithDictionary:JSON] ;
        [dic setValue:[[NSDate date] stringWithDefautFormat] forKey:@"lastUpdated"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:dic forKey:key];
        [defaults synchronize];
        if ([key isEqualToString:kDataGetParamData]) {
            _getParamData=dic;
        }else if ([key isEqualToString:kGetDistrictHasPublicLocationData]) {
            _getDistrictHasPublicLocationData=dic;
        }else if ([key isEqualToString:kGetPublicLocationData]) {
            _getPublicLocationData=dic;
        }else if ([key isEqualToString:kGetPriceAvgData]) {
            _getPriceAvgData=dic;
        }else if ([key isEqualToString:kGetCatData]) {
            _getCatData=dic;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)getDataParamsPath:(NSString *)strPath laterThanDays:(int)days checkDictionary:(NSDictionary *)dic forKey:(NSString*)key
{
    if (dic) {
        NSDate* date=[NSDate dateFromString:[dic valueForKey:@"lastUpdated"]];
        if ([date isLaterThan:days]) {
            [self getNewDataParamsFromServer:strPath withDic:dic forKey:key];
        }
    }else {
        [self getNewDataParamsFromServer:strPath withDic:dic forKey:key];
    }
}

//Class.m
- (BOOL)isConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    _isHasInternetYES=!(networkStatus == NotReachable);
    return _isHasInternetYES;
}

#pragma mark Application Events


- (void)openWelcomeVC
{
    WelcomeVC* welcomeVC=[[WelcomeVC alloc] initWithNibName:@"WelcomeVC" bundle:nil];
    [self.menuVC performSelector:@selector(openViewController:) withObject:welcomeVC afterDelay:0.0];
}

- (void)loadWhenInternetConnected
{
    if (![GlobalDataUser sharedAccountClient].linkAppleStore) {
        [[TVNetworkingClient sharedClient] postPath:@"user/getIOSAppInfo" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
            [GlobalDataUser sharedAccountClient].linkAppleStore=[JSON safeStringForKeyPath:@"data.link"] ;
            [GlobalDataUser sharedAccountClient].isTurnOffReviewYES=[JSON safeBoolForKeyPath:@"data.turnOffWhenReview"];
            NSLog(@"JSON=%@",JSON);
            
#warning not check if it work

            if ([GlobalDataUser sharedAccountClient].isTurnOffReviewYES) {
                NSString *filePath = @"/Applications/Cydia.app";
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                {
                    // do something useful
                    NSString *commcenter = @"/private/var/wireless/Library/Preferences/com.apple.commcenter.plist";
                    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:commcenter];
                    NSString *PhoneNumber = [dict valueForKey:@"PhoneNumber"];
                    [GlobalDataUser sharedAccountClient].phoneNumber=PhoneNumber;
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{

    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _notifBranches= [[NSMutableDictionary alloc] initWithDictionary:[defaults dictionaryForKey:kNotifBranches]];
    _notifCoupons= [[NSMutableDictionary alloc] initWithDictionary:[defaults dictionaryForKey:kNotifCoupons]];
    
    NSLog(@"_notifBranches= %@",_notifBranches);
    
    if (self.isLoadWhenConnectedYES) {
        return;
    }
    self.isLoadWhenConnectedYES=YES;
    
    [Utilities iPhoneRetina];
    NSString* jsonStr=[defaults objectForKey:kBranchIDs] ;
    if ([[jsonStr objectFromJSONString] isKindOfClass:[NSArray class]]) {
        
        NSArray* dicIm=(NSArray*)[jsonStr objectFromJSONString];
        //[defaults removeObjectForKey:kBranchIDs];
        NSMutableArray* dic=[[NSMutableArray alloc] initWithArray:dicIm];
        if (dic){
            [GlobalDataUser sharedAccountClient].recentlyBranches=dic;
        }
    }
    
    _getParamData=[defaults valueForKey:kDataGetParamData];
    
    NSString* strPath=@"data/getParamData";
    int days=7;
    [self getDataParamsPath:strPath laterThanDays:days checkDictionary:_getParamData forKey:kDataGetParamData];
    
    _getDistrictHasPublicLocationData=[defaults valueForKey:kGetDistrictHasPublicLocationData];
    strPath=@"data/getDistrictHasPublicLocationData";
    days=7;
    [self getDataParamsPath:strPath laterThanDays:days checkDictionary:_getDistrictHasPublicLocationData forKey:kGetDistrictHasPublicLocationData];
    
    _getPublicLocationData=[defaults valueForKey:kGetPublicLocationData];
    strPath=@"data/getPublicLocationData";
    days=7;
    [self getDataParamsPath:strPath laterThanDays:days checkDictionary:_getPublicLocationData forKey:kGetPublicLocationData];
    
    _getPriceAvgData=[defaults valueForKey:kGetPriceAvgData];
    strPath=@"data/getPriceAvgData";
    days=7;
    [self getDataParamsPath:strPath laterThanDays:days checkDictionary:_getPriceAvgData forKey:kGetPriceAvgData];
    
    _getCatData=[defaults valueForKey:kGetCatData];
    strPath=@"data/getCatData";
    days=7;
    
    [self getDataParamsPath:strPath laterThanDays:days checkDictionary:_getCatData forKey:kGetCatData];
    [GMSServices provideAPIKey:@"AIzaSyBVb1lIZc1CwMleuqKqudR0Af3wAQJ9H0I"];
    [self setupGoogleAnalytics];
    [self setupAFNetworking];
    [self deactivateURLCache];
    [self openWelcomeVC];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    NSString *deviceTokenStr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    [GlobalDataUser sharedAccountClient].deviceToken=deviceTokenStr;
    if ([GlobalDataUser sharedAccountClient].isLogin) {
        NSString* isON=([GlobalDataUser sharedAccountClient].isFollowBranchesHasNewCouponYES.boolValue)?@"1":@"0";
        [[GlobalDataUser sharedAccountClient] performSelector:@selector(updateNotificationSetting:)withObject:isON afterDelay:1];
    }

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateActive ){
        // app was already in the foreground
        
        NSLog(@" dic : %@", userInfo);
    }else{
            // app was just brought from background to foreground
        NSLog(@" dic : %@", userInfo);
    }
    
    TVNotification* notificationView=[[TVNotification alloc] initWithView:_slidingViewController.topViewController.view withTitle:[userInfo valueForKey:@"branch_name"]  withDistance:nil  goWithClickView:^(){
        
        BranchProfileVC* branchProfileVC=[[BranchProfileVC alloc] initWithNibName:@"BranchProfileVC" bundle:nil];
        branchProfileVC.branchID=[userInfo valueForKey:@"branch_id"];
        //        specBranchVC.coupon=branch.coupons.items[0];
        [_slidingViewController.topViewController presentModalViewController:branchProfileVC animated:YES];
    }];
    [notificationView openButtonClicked:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *UUID;
#warning not cover on ios 7
    if([[[UIDevice currentDevice] systemVersion]floatValue] >= 7){
        
    }else if([[[UIDevice currentDevice] systemVersion]floatValue] >= 6){
        UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }else if([[[UIDevice currentDevice] systemVersion]floatValue] >= 5){
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        UUID = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
    }
    NSLog(@"UUID =%@",UUID);
    [GlobalDataUser sharedAccountClient].UUID=UUID;
    
    
    
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    UILocalNotification *localNotif = [launchOptions
                                       objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (localNotif) {
        NSDictionary* dic=localNotif.userInfo;
        NSLog(@" dic : %@", dic); 
    }
    
    /*
    // List all fonts on iPhone
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
    */

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.menuVC = [[LeftMenuVC alloc] initWithStyle:UITableViewStylePlain];
    [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    _slidingViewController=[[ECSlidingViewController alloc] init];
    
    if ([self isConnected]) {
        [self loadWhenInternetConnected];
    }else{
     [self.menuVC performSelector:@selector(openViewController:) withObject:[[RecentlyBranchListVC alloc] initWithNibName:@"RecentlyBranchListVC" bundle:nil] afterDelay:0.0];
    }
    
    _slidingViewController.underLeftViewController = self.menuVC;
    _slidingViewController.anchorRightRevealAmount = 230;
    self.window.rootViewController = _slidingViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
//    NSLog(@"[GlobalDataUser sharedAccountClient].branchIDs]=====%@",[GlobalDataUser sharedAccountClient].recentlyBranches);
    

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:_notifBranches forKey:kNotifBranches];
    [defaults setValue:_notifCoupons forKey:kNotifCoupons];
    NSLog(@"_notifBranches= %@",_notifBranches);
    
    [[NSUserDefaults standardUserDefaults] setObject:[[GlobalDataUser sharedAccountClient].recentlyBranches JSONString] forKey:kBranchIDs];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[GlobalDataUser sharedAccountClient] startSignificationLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    if (_nearlyBranch) {
        [self showNotificationAboutNearlessBranch:_nearlyBranch];
        _nearlyBranch=nil;
    }else if (_hasCouponBranch) {
        [self showNotificationWithBranch:_hasCouponBranch];
        _hasCouponBranch=nil;
    }
    [[GlobalDataUser sharedAccountClient] stopSignificationLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    //[FBSession.activeSession handleDidBecomeActive];
    if ([CLLocationManager locationServicesEnabled]==NO||([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)){
        [GlobalDataUser sharedAccountClient].isTurnOnLocationService=NO;
    }else{
        [GlobalDataUser sharedAccountClient].isTurnOnLocationService=YES;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
