/*
 * Copyright 2012 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "LoginVC.h"
#import "TVAppDelegate.h"
#import "GlobalDataUser.h"
#import "TVNetworkingClient.h"
#import "Utilities.h"
#import "AFHTTPRequestOperation.h"
#import "UserRegisterVC.h"
#import "UINavigationBar+JTDropShadow.h"
#import "ForgetPassVC.h"
#import "GlobalDataUser.h"
#import "TSMessage.h"
#import "SVProgressHUD.h"
#import  <JSONKit.h>
#import "NSDictionary+Extensions.h"
@interface LoginVC
(){
    @private
    NSMutableData *_responseData;
    BOOL _isRequestSendYES;
}
@end
@implementation LoginVC
#pragma mark Setup Methods


#pragma mark ViewControllerDelegate

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar dropShadow];
    // Setup View and Table View
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    /*
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    */
    
    NSURLRequest* request=[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://id.vatgia.com/dang-nhap/oauth?_cont=anuong://login&client_id=%@",kVatgiaClientID]]];
    [_webView loadRequest:request];
    [_webView setDelegate:self];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView setDelegate:nil];[SVProgressHUD dismiss];
}
- (void)viewDidUnload
{
    [self.webView setDelegate:nil];
    [self setWebView:nil];
    [super viewDidUnload];
    [SVProgressHUD dismiss];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Helper

- (void)closeViewController {
    if (_isPushNaviYES )
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissModalViewControllerAnimated:YES];
}

-(void)hasPermissionAndGoGetThing{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 if (self.userDidLogin) {
                     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                             user.id,@"openid_id" ,
                                             @"FACEBOOK",@"openid_service",
                                             [user objectForKey:@"email"],@"email",
                                             user.name,@"name",
                                             user.birthday,@"dob",
                                             nil];
                     NSLog(@"%@",params	);
                     // TODO turn on login via openid
                     [[TVNetworkingClient sharedClient] postPath:@"user/loginOpenid" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
                         NSLog(@"%@",JSON);
                         NSLog(@"%ld",(long)operation.response.statusCode);
                         [[GlobalDataUser sharedAccountClient] setGlocalDataUser:JSON];
                         self.userDidLogin();
                         [SVProgressHUD dismiss];
                         [self closeViewController];
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [SVProgressHUD dismiss];
                         // TODO with error
                         NSLog(@"%@",error);
                         if (self.userLoginFail)
                         {
                             self.userLoginFail();
                         }
                     }];
                 }
             }else{
                 // TODO with error
                 NSLog(@"%@",error);
             }
         }];
    }
}



-(void)goWithDidLogin:(void (^)())userDidLogin thenLoginFail:(void (^)())userLoginFail{
    self.userDidLogin =userDidLogin;
    self.userLoginFail=userLoginFail;
}
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSString* strJSON = [[NSString alloc] initWithData:_responseData
                                              encoding:NSUTF8StringEncoding] ;
    NSDictionary* dic=[strJSON objectFromJSONString];
//    NSLog(@"_responseData===%@",strJSON);
//    NSLog(@"dic=%@",dic);
    NSDictionary* dicAcc=[[[dic safeArrayForKey:@"objects"] lastObject] safeDictForKey:@"acc"];
    if (dicAcc){
        [[GlobalDataUser sharedAccountClient] setGlocalDataUser:dicAcc];
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Đăng nhập thành công"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeSuccess];
    }
    else
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Đăng nhập thất bại"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeError];
    [SVProgressHUD dismiss];
    if (self.userDidLogin)
    {
        [self closeViewController];
        self.userDidLogin();
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    // The request has failed for some reason!
    // Check the error var
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge previousFailureCount] == 0) {
        
        NSURLCredential *newCredential;
        newCredential = [NSURLCredential credentialWithUser:kVatgiaClientID
                                                   password:kVatgiaClientSecret
                                                persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password
        // in the preferences are incorrect
        //[self showPreferencesCredentialsAreIncorrectPanel:self];
    }
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (![self isBeingDismissed]) {
        if(![SVProgressHUD isVisible])[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    
    NSURL* url = [request URL];
    if (navigationType == UIWebViewNavigationTypeOther) {
        NSString *string = [url absoluteString];
        NSLog(@"string===%@",string);
        if ([string rangeOfString:@"anuong://login?"].location == NSNotFound) {
            NSLog(@"string not contains in %@",string);
        } else {
            if (_isRequestSendYES) {
                return NO;
            }
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if([elts count] < 2) continue;
                [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
            }
            
            NSLog(@"params===%@",params);
            NSString* strTokenKey=[NSString stringWithFormat:@"https://id.vatgia.com/oauth2/accessCode/%@?with=acc",[params objectForKey:@"access_code" ]];
            NSLog(@"strTokenKey===%@",strTokenKey);
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            //Set Params
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            [request setHTTPShouldHandleCookies:NO];
            [request setTimeoutInterval:30];
            [request setHTTPMethod:@"GET"];
            [request setURL:[[NSURL alloc] initWithString:strTokenKey]];
            NSURLConnection *connect=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            _isRequestSendYES=YES;
            [connect start];        
            return NO;
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD dismiss];
}

#pragma mark - IBAction

-(void)backButtonClicked:(id)sender{
    [self closeViewController];
}

- (IBAction)signupButtonClicked:(id)sender {
    UserRegisterVC *viewController=[[UserRegisterVC alloc] initWithNibName:@"UserRegisterVC" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)forgetPasswordButtonClicked:(id)sender {
    ForgetPassVC* viewController=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController = [[ForgetPassVC alloc] initWithNibName:@"ForgetPassVC_iPhone" bundle:nil];
    } else {
        viewController = [[ForgetPassVC alloc] initWithNibName:@"ForgetPassVC_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)fbLoginBtnClicked:(id)sender {
    [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObject:@"email"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          if (session.isOpen) {
                                              [self hasPermissionAndGoGetThing];
                                          } else {
                                              [TSMessage showNotificationInViewController:self
                                                                                withTitle:@"Có lỗi xảy ra trong quá trình đăng nhập. Vui lòng thử lại hoặc sử dụng tài khoản khác"
                                                                              withMessage:nil
                                                                                 withType:TSMessageNotificationTypeWarning];
                        ;                 }
    }];
}

#pragma mark UITextFieldDelegate


#pragma mark -


@end
