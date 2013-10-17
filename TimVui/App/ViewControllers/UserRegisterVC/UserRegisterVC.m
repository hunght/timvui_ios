//
//  RegisterViewController.m
//  CityOffers
//
//  Created by Nguyen Mau Dat on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserRegisterVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import "TVNetworkingClient.h"
#import "Utilities.h"
#import "AFHTTPRequestOperation.h"
#import "AuthenCodeVC.h"

@interface UserRegisterVC ()
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation UserRegisterVC
@synthesize btnRegister;
@synthesize scrollview;
@synthesize txfPassword;
@synthesize txfPhone;
@synthesize txfConfirmPassword;



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *fields = @[ self.txfName,self.txfPhone,txfPassword,txfConfirmPassword];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    // Setup View and Table View
    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_pattern_background"]]];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"img_button_large_off"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"img_button_large_on"] forState:UIControlStateHighlighted];
    [_btn_Cancel setBackgroundImage:[UIImage imageNamed:@"img_button_cancel_off"] forState:UIControlStateNormal];
    [_btn_Cancel setBackgroundImage:[UIImage imageNamed:@"img_button_cancel_on"] forState:UIControlStateHighlighted];
    btnRegister.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(17)];
    _btn_Cancel.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(17)];
}

-(void)didReceiveMemoryWarning{
    [[SDImageCache sharedImageCache] clearMemory];
    [super didReceiveMemoryWarning];
}

-(void)viewWillUnload{
    user_password=txfPassword.text;
    user_confirm_password=txfConfirmPassword.text;
    user_phone=txfPhone.text;
    [super viewWillUnload];
    
}

- (void)viewDidUnload
{

    [self setTxfPassword:nil];
    [self setTxfPhone:nil];
    [self setTxfConfirmPassword:nil];
    [self setScrollview:nil];
    [self setBtnRegister:nil];
    [self setBtn_Cancel:nil];
    [self setTxfName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)postAPIUserCreatePhone {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            txfPhone.text,@"phone" ,
                            txfPassword.text,@"password",
                            _txfName.text,@"name",
                            nil];
    NSLog(@"%@",params);
    [[TVNetworkingClient sharedClient] postPath:@"user/createPhone" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        AuthenCodeVC* viewController=nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            viewController = [[AuthenCodeVC alloc] initWithNibName:@"AuthenCodeVC_iPhone" bundle:nil];
        } else {
            viewController = [[AuthenCodeVC alloc] initWithNibName:@"AuthenCodeVC_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:viewController animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
    }];
}

#pragma mark IBAction

- (IBAction)userRegisterClicked:(id)sender {
    [self.view endEditing:YES];
        if ([Utilities validatePhone:txfPhone.text]) {
            if ([Utilities validatePassword:txfPassword.text withConfirmPass:txfConfirmPassword.text]){
                if ([Utilities validateString:_txfName.text])
                    [self postAPIUserCreatePhone];
            }
        }else
            [Utilities showAlertWithMessage:@"Xin dien thong tin day du"];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)getPhotoUserButtonClicked:(id)sender {
    [[SDImageCache sharedImageCache] clearMemory];

}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:txfPhone]) {
        [txfPhone setKeyboardType:UIKeyboardTypePhonePad];
    }
    [self.keyboardControls setActiveField:textField];
}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view = keyboardControls.activeField;
    [self.scrollview scrollRectToVisible:view.frame animated:YES];
}
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:NO];
}


@end
