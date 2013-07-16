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
#import "Ultilities.h"
#import "AFHTTPRequestOperation.h"
#import "UserRegisterVC.h"
#import "UINavigationBar+JTDropShadow.h"
#import "ForgetPassVC.h"
#import "GlobalDataUser.h"
#import "TSMessage.h"
#import "SVProgressHUD.h"
@implementation LoginVC

#pragma mark Setup Methods


#pragma mark ViewControllerDelegate

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* urlStr=[NSString stringWithFormat:@"https://id.vatgia.com/dang-nhap/oauth?_cont=http://anuong.net/tai-khoan/dang-nhap&client_id={$client_id}"];
    NSURLRequest* request=[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:urlStr]];
    [_webView loadRequest:request];
    [_webView setDelegate:self];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
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

// Displays the user's name and profile picture so they are aware of the Facebook
// identity they are logged in as.
- (void)getInfoAccountFacebook{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"email"]
                                          defaultAudience:FBSessionDefaultAudienceEveryone
                                        completionHandler:^(FBSession *session, NSError *error) {
                                            if (!error) {
                                                // Now have the permission
                                                
                                            } else {
                                                [SVProgressHUD dismiss];
                                                // Facebook SDK * error handling *
                                                // if the operation is not user cancelled
                                                if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                    NSLog(@"%@",error);
                                                }
                                            }
    }];
}

-(void)goWithDidLogin:(void (^)())userDidLogin thenLoginFail:(void (^)())userLoginFail{
    self.userDidLogin =userDidLogin;
    self.userLoginFail=userLoginFail;
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
