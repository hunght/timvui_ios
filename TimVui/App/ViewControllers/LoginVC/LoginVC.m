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
    
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar.png"]
                                                      forBarMetrics:UIBarMetricsDefault];
    }
    // Setup View and Table View
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"back_OFF"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_OFF_hover"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    if (!SharedAppDelegate.session.isOpen) {
        // create a fresh session object
        SharedAppDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (SharedAppDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [SharedAppDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                if (SharedAppDelegate.session.isOpen) {
                    // if a user logs out explicitly, we delete any cached token information, and next
                    // time they run the applicaiton they will be presented with log in UX again; most
                    // users will simply close the app or switch away, without logging out; this will
                    // cause the implicit cached-token login to occur on next launch of the application
                    [SharedAppDelegate.session closeAndClearTokenInformation];
                }
            }];
        }
    }
    
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

// Displays the user's name and profile picture so they are aware of the Facebook
// identity they are logged in as.
- (void)getInfoAccountFacebook{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             if ([_delegate respondsToSelector:@selector(userFacebookDidLogin)]) {
                 NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                         user.id,@"openid_id" ,
                                         @"FACEBOOK",@"openid_service",
                                         @"email",@"email",
                                         user.name,@"name",
                                         user.birthday,@"dob",
                                         nil];
                 
                 [[TVNetworkingClient sharedClient] postPath:@"http://anuong.hehe.vn/api/user/openidLogin" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
                     NSLog(@"%@",JSON);
                     NSLog(@"%ld",(long)operation.response.statusCode);
                     [GlobalDataUser sharedClient].isLogin=YES;
                     [GlobalDataUser sharedClient].username=user.name;
                     [GlobalDataUser sharedClient].facebookID=user.id;
                     [GlobalDataUser sharedClient].avatarImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", user.id];
                     NSLog(@"image link: %@",[GlobalDataUser sharedClient].avatarImageURL);
                     [_delegate userFacebookDidLogin];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"%@",error);
                     NSLog(@"%ld",(long)operation.response.statusCode);
                 }];
             }
             [self dismissModalViewControllerAnimated:YES];
         }else{
             //Todo
             NSLog(@"%@",error);
         }
     }];
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

#pragma mark - IBAction

- (IBAction)facebookLoginButtonClicked:(id)sender {
    // get the app delegate so that we can access the session property
    
    if (SharedAppDelegate.session.state != FBSessionStateCreated) {
        // Create a new, logged out session.
        SharedAppDelegate.session = [[FBSession alloc] init];
    }
    // if the session isn't open, let's open it now and present the login UX to the user
    [SharedAppDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
        // and here we make sure to update our UX according to the new session state
        if (SharedAppDelegate.session.isOpen) {
            [FBSession setActiveSession:SharedAppDelegate.session];

            [self getInfoAccountFacebook];
        }
    }];
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
    viewController.isUpdateProfileYES=NO;
    [self.navigationController pushViewController:viewController animated:YES];
}




@end
