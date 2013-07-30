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

#import "ForgetPassVC.h"
#import "TVAppDelegate.h"
#import "GlobalDataUser.h"
#import "TVNetworkingClient.h"
#import "Utilities.h"
#import "AFHTTPRequestOperation.h"
#import "UserRegisterVC.h"
#import "UINavigationBar+JTDropShadow.h"
#import "AuthenCodeVC.h"
@interface ForgetPassVC ()


@end

@implementation ForgetPassVC
@synthesize delegate=_delegate;

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ViewControllerDelegaet

- (void)viewDidUnload
{
    [self setTfdPhoneNumber:nil];
    [self setScrollView:nil];
    [self setBtnContinue:nil];
    [self setLblNoticeText:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar dropShadow];
    _lblNoticeText.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_pattern_background"]]];
    
    [_btnContinue setBackgroundImage:[UIImage imageNamed:@"img_buttom-big-off"] forState:UIControlStateNormal];
    [_btnContinue setBackgroundImage:[UIImage imageNamed:@"img_button_big_on"] forState:UIControlStateHighlighted];
    _btnContinue.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(17)];
    
    // Setup View and Table View
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}



#pragma mark UITextFieldDelegate
//implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_tfdPhoneNumber]) {
        [_tfdPhoneNumber setKeyboardType:UIKeyboardTypePhonePad];
    }
}




#pragma mark Helper
- (void)postAPIUserLogin {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _tfdPhoneNumber.text,@"password",
                            nil];
    
    [[TVNetworkingClient sharedClient] postPath:@"user/login" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        NSLog(@"%ld",(long)operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld",(long)operation.response.statusCode);
    }];
}

#pragma mark - IBAction

- (IBAction)contiuneButtonClicked:(id)sender {
        
        if ([Utilities validatePhone:_tfdPhoneNumber.text]){

            [self postAPIUserLogin];
        }else
            [Utilities showAlertWithMessage:@"Xin điền đúng thông tin Email/SĐT"];
    
    AuthenCodeVC* viewController=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController = [[AuthenCodeVC alloc] initWithNibName:@"AuthenCodeVC_iPhone" bundle:nil];
    } else {
        viewController = [[AuthenCodeVC alloc] initWithNibName:@"AuthenCodeVC_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
