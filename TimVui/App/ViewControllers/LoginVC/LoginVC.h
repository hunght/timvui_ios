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

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"
#import <FacebookSDK/FacebookSDK.h>


@class TPKeyboardAvoidingScrollView;


@interface LoginVC : UIViewController<UITextFieldDelegate,FBLoginViewDelegate,BSKeyboardControlsDelegate>

@property (copy) void (^userLoginFail)();
@property (copy) void (^userDidLogin)();
@property (nonatomic, assign)BOOL isPushNaviYES;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *tfdUsername;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *tfdPassword;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnLogin;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnRegistering;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblOr;

@property (unsafe_unretained, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblLostPass;

//Action
- (IBAction)userLoginButtonClicked:(id)sender;
- (IBAction)signupButtonClicked:(id)sender;
- (IBAction)forgetPasswordButtonClicked:(id)sender;

-(void)goWithDidLogin:(void (^)())userDidLogin thenLoginFail:(void (^)())userLoginFail;
@end

