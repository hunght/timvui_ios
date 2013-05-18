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
#import "AppDelegate.h"
#import "GlobalDataUser.h"
#import "TVNetworkingClient.h"
#import "Ultilities.h"
#import "AFHTTPRequestOperation.h"
#import "UserRegisterVC.h"
#import "UINavigationBar+JTDropShadow.h"
#import "ForgetPassVC.h"
@interface LoginVC ()

@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;

@end

@implementation LoginVC
@synthesize buttonLogin = _buttonLoginLogout;
@synthesize delegate=_delegate;

-(void)backButtonClicked:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar dropShadowWithOffset:CGSizeMake(0, 5) radius:5 color:[UIColor blackColor] opacity:1];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_pattern_background"]]];
    
    
    [_btnFBRegistering setBackgroundImage:[UIImage imageNamed:@"img_button-face-off"] forState:UIControlStateNormal];
    [_btnFBRegistering setBackgroundImage:[UIImage imageNamed:@"img_button-face-on"] forState:UIControlStateHighlighted];
    [_btnFBRegistering.titleLabel setTextColor:[UIColor colorWithRed:(59.0f/255.0f) green:(89.0f/255.0f) blue:(152.0f/255.0f) alpha:1.0f]];
    
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



#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_tfdUsername]) {
        [_tfdUsername setKeyboardType:UIKeyboardTypeEmailAddress];
    }
}



#pragma mark Template generated code

- (void)viewDidUnload
{
    self.buttonLogin = nil;
    [self setTfdUsername:nil];
    [self setTfdPassword:nil];
    [self setScrollView:nil];
    [self setBtnFBRegistering:nil];
    [self setBtnLogin:nil];
    [self setBtnRegistering:nil];
    [self setLblOr:nil];
    [self setLblLostPass:nil];
    [self setFBLoginView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}



- (void)postAPIUserLogin {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _tfdUsername.text,@"username" ,
                            _tfdPassword.text,@"password",
                            nil];
    
    [[TVNetworkingClient sharedClient] postPath:@"http://anuong.hehe.vn/api/user/login" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        NSLog(@"%ld",(long)operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld",(long)operation.response.statusCode);
    }];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - IBAction

- (IBAction)facebookLoginButtonClicked:(id)sender {
    // get the app delegate so that we can access the session property
    
}



- (IBAction)userLoginButtonClicked:(id)sender {
    if ([Ultilities validatePassword:_tfdPassword.text]) {
        
        if ([Ultilities validateEmail:_tfdUsername.text]) {
            //
            [self postAPIUserLogin];
        }else if ([Ultilities validatePhone:_tfdUsername.text]){

            [self postAPIUserLogin];
        }else
            [Ultilities showAlertWithMessage:@"Xin điền đúng thông tin Email/SĐT"];
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




@end
