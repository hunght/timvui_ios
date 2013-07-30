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

#import "AuthenCodeVC.h"
#import "TVAppDelegate.h"
#import "GlobalDataUser.h"
#import "TVNetworkingClient.h"
#import "Utilities.h"
#import "AFHTTPRequestOperation.h"
#import "UserRegisterVC.h"
#import "UINavigationBar+JTDropShadow.h"
@interface AuthenCodeVC ()


@end

@implementation AuthenCodeVC
@synthesize delegate=_delegate;

-(void)backButtonClicked:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar dropShadow];
    
    _lblNoticeText.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_pattern_background"]]];
    
    [_btnDone setBackgroundImage:[UIImage imageNamed:@"img_buttom-big-off"] forState:UIControlStateNormal];
    [_btnDone setBackgroundImage:[UIImage imageNamed:@"img_button_big_on"] forState:UIControlStateHighlighted];
    _btnDone.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(17)];
    
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
    
}

#pragma mark Template generated code

- (void)viewDidUnload
{
    [self setTfdAuthenCode:nil];
    [self setScrollView:nil];
    [self setBtnDone:nil];
    [self setLblNoticeText:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)postCreatePhoneVerify {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _tfdAuthenCode.text,@"password",
                            nil];
    [[TVNetworkingClient sharedClient] postPath:@"user/createPhoneVerify" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        [[GlobalDataUser sharedAccountClient] setGlocalDataUser:JSON];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld",(long)operation.response.statusCode);
    }];
}

#pragma mark - IBAction



- (IBAction)contiuneButtonClicked:(id)sender {
        
        if ([Utilities validatePhone:_tfdAuthenCode.text]){

            [self postCreatePhoneVerify];
        }else
            [Utilities showAlertWithMessage:@"Xin điền đúng thông tin Email/SĐT"];
}




@end
