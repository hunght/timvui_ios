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
#import "TPKeyboardAvoidingScrollView.h"
#import "GlobalDataUser.h"
#import "TSMessage.h"
#import "SVProgressHUD.h"
@implementation LoginVC




#pragma mark Setup Methods

- (void)setupViewLayout {
    [self.navigationController.navigationBar dropShadowWithOffset:CGSizeMake(0, 5) radius:5 color:[UIColor blackColor] opacity:1];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_pattern_background"]]];
    
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"img_buttom-big-off"] forState:UIControlStateNormal];
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"img_button_big_on"] forState:UIControlStateHighlighted];
    [_btnLogin.titleLabel setFont:[UIFont fontWithName:@"UVNVanBold" size:(17)]];
    
    _lblOr.textColor = [UIColor colorWithRed:(253.0f/255.0f) green:(83/255.0f) blue:(83/255.0f) alpha:1.0f];
    
    // Setup View and Table View
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

#pragma mark ViewControllerDelegate

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewLayout];
    
    NSArray *fields = @[ self.tfdUsername,self.tfdPassword];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

- (void)viewDidUnload
{
    [self setTfdUsername:nil];
    [self setTfdPassword:nil];
    [self setScrollView:nil];
    [self setBtnLogin:nil];
    [self setBtnRegistering:nil];
    [self setLblOr:nil];
    [self setLblLostPass:nil];
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
                                            }                                        }];
   
}


- (void)postAPIUserLogin {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _tfdUsername.text,@"username" ,
                            _tfdPassword.text,@"password",
                            nil];
    
    [[TVNetworkingClient sharedClient] postPath:@"user/login" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        [[GlobalDataUser sharedAccountClient] setGlocalDataUser:JSON];
        if (self.userDidLogin)
        {
            
            [self closeViewController];
            self.userDidLogin();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userLoginFail)
        {
            self.userLoginFail();
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
- (IBAction)userLoginButtonClicked:(id)sender {
    if ([Ultilities validatePassword:_tfdPassword.text]) {
        
        if ([Ultilities validateEmail:_tfdUsername.text]) {
            //
            [self postAPIUserLogin];
        }else if ([Ultilities validatePhone:_tfdUsername.text]){
            
            [self postAPIUserLogin];
        }else
            [Ultilities showAlertWithMessage:@"Xin điền đúng thông tin SĐT"];
    }
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
                                              [SharedAppDelegate showAlertAboutSomething:@"Có lỗi xảy ra trong quá trình đăng nhập. Vui lòng thử lại hoặc sử dụng tài khoản khác"];
                        ;                 }
    
                                  }];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_tfdUsername]) {
        [_tfdUsername setKeyboardType:UIKeyboardTypePhonePad];
    }
    [self.keyboardControls setActiveField:textField];
}

#pragma mark -
#pragma mark Keyboard Controls Delegate


- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:NO];
}


@end
