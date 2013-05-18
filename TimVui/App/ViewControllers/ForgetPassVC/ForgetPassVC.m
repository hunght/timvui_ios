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
#import "AppDelegate.h"
#import "GlobalDataUser.h"
#import "TVNetworkingClient.h"
#import "Ultilities.h"
#import "AFHTTPRequestOperation.h"
#import "UserRegisterVC.h"
#import "UINavigationBar+JTDropShadow.h"
#import "AuthenCodeVC.h"
@interface ForgetPassVC ()


@end

@implementation ForgetPassVC
@synthesize delegate=_delegate;

-(void)backButtonClicked:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar dropShadowWithOffset:CGSizeMake(0, 5) radius:5 color:[UIColor blackColor] opacity:1];
    _lblNoticeText.font = [UIFont fontWithName:@"UVNVanBold" size:(15)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_pattern_background"]]];
    
    

    [_btnContinue setBackgroundImage:[UIImage imageNamed:@"img_buttom-big-off"] forState:UIControlStateNormal];
    [_btnContinue setBackgroundImage:[UIImage imageNamed:@"img_button_big_on"] forState:UIControlStateHighlighted];
    _btnContinue.titleLabel.font = [UIFont fontWithName:@"UVNVanBold" size:(17)];
    
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
    [self setTfdPhoneNumber:nil];
    [self setScrollView:nil];
    [self setBtnContinue:nil];
    [self setLblNoticeText:nil];
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
                            _tfdPhoneNumber.text,@"password",
                            nil];
    
    [[TVNetworkingClient sharedClient] postPath:@"http://anuong.hehe.vn/api/user/login" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        NSLog(@"%ld",(long)operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld",(long)operation.response.statusCode);
    }];
}

#pragma mark - IBAction




- (IBAction)contiuneButtonClicked:(id)sender {
        
        if ([Ultilities validatePhone:_tfdPhoneNumber.text]){

//            [self postAPIUserLogin];
        }else
            [Ultilities showAlertWithMessage:@"Xin điền đúng thông tin Email/SĐT"];
    
    
    AuthenCodeVC* viewController=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController = [[AuthenCodeVC alloc] initWithNibName:@"AuthenCodeVC_iPhone" bundle:nil];
    } else {
        viewController = [[AuthenCodeVC alloc] initWithNibName:@"AuthenCodeVC_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}






@end
