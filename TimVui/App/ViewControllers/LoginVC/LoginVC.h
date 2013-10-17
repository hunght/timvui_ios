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

@class TPKeyboardAvoidingScrollView;

@interface LoginVC : MyViewController<UITextFieldDelegate,UIWebViewDelegate>

@property (copy) void (^userLoginFail)();
@property (copy) void (^userDidLogin)();
@property (nonatomic, assign)BOOL isPushNaviYES;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

-(void)goWithDidLogin:(void (^)())userDidLogin thenLoginFail:(void (^)())userLoginFail;

@end

