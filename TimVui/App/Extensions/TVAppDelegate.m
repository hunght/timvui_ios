//
//  AppDelegate.m
//  TimVui
//
//  Created by Hoang The Hung on 3/22/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVAppDelegate.h"
#import "MainVC.h"
#import "AFNetworkActivityIndicatorManager.h"

#import "ECSlidingViewController.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import <GoogleMaps/GoogleMaps.h>
#import "WelcomeVC.h"
#import "TSMessage.h"

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

-(void)showNotificationAboutSomething:(TVBranch*)_branch
{
    NSString *notificationTitle = _branch.branchID;
    NSString *notificationDescription = @"what";
    
    CGFloat duration = 2.0f;
    
    [TSMessage showNotificationInViewController:_slidingViewController.topViewController
                                      withTitle:notificationTitle
                                    withMessage:notificationDescription
                                       withType:TSMessageNotificationTypeMessage
                                   withDuration:duration
                                   withCallback:nil
                                withButtonTitle:@"Update" 
                             withButtonCallback:^{
                                 [TSMessage showNotificationInViewController:_slidingViewController.topViewController
                                                                   withTitle:@"what"
                                                                 withMessage:nil
                                                                    withType:TSMessageNotificationTypeSuccess];
                             }
                                     atPosition:TSMessageNotificationPositionBottom
                            canBeDismisedByUser:YES];

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

- (void)setupSlidingViewController {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.menuVC = [[LeftMenuVC alloc] initWithStyle:UITableViewStylePlain];
    WelcomeVC* welcomeVC=[[WelcomeVC alloc] initWithNibName:@"WelcomeVC" bundle:nil];
    
    _slidingViewController=[[ECSlidingViewController alloc] init];
    _slidingViewController.topViewController=welcomeVC;
    _slidingViewController.underLeftViewController = self.menuVC;
    _slidingViewController.anchorRightRevealAmount = 230;
    self.window.rootViewController = _slidingViewController;
}


#pragma mark Application Events

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyBVb1lIZc1CwMleuqKqudR0Af3wAQJ9H0I"];
    [self setupGoogleAnalytics];
    [self setupAFNetworking];
    [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self deactivateURLCache];
    [self setupSlidingViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
