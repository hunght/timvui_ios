//
//  RegisterViewController.m
//  CityOffers
//
//  Created by Nguyen Mau Dat on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserRegisterVC.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import "AFAppDotNetAPIClient.h"
#import "Ultilities.h"
#import "AFHTTPRequestOperation.h"

@interface UserRegisterVC ()

@end

@implementation UserRegisterVC
@synthesize btnRegister;
@synthesize imgViewAvatar;
@synthesize scrollview;
@synthesize txfName;
@synthesize txfPassword;
@synthesize txfPhone;
@synthesize txfConfirmPassword;
@synthesize isUpdateProfileYES;
@synthesize imageAvatar;



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (isUpdateProfileYES) {
        [btnRegister setTitle:NSLocalizedString(@"Update User Account", nil) forState:UIControlStateNormal];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];

}

- (void)viewDidLoad
{
    [_labelFirstName setText:NSLocalizedString(@"User FirstName", nil)];
    [_labelReentrePassword setText:NSLocalizedString(@"Reenter Pass", nil)];
    [_labelPhoneNumber setText:NSLocalizedString(@"Phone Number", nil)];
    [btnRegister setTitle:NSLocalizedString(@"Regist User Account", nil) forState:UIControlStateNormal];
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    // Setup View and Table View
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"back_OFF"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_OFF_hover"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_xem-chi-tiet_on.png"] forState:UIControlStateHighlighted];
    [btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _svos = scrollview.contentOffset;
    // Do any additional setup after loading the view from its nib.
    if (isUpdateProfileYES) {
        
    }else{


    }

    if (isUpdateProfileYES) 
        self.trackedViewName=@"Me_UpdateInfo";
    else
        self.trackedViewName=@"Signup";
    
    imgViewAvatar.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)didReceiveMemoryWarning{
    [[SDImageCache sharedImageCache] clearMemory];
    [super didReceiveMemoryWarning];
}
-(void)viewWillUnload{
    user_firstName=txfName.text;
    user_password=txfPassword.text;
    user_confirm_password=txfConfirmPassword.text;
    user_phone=txfPhone.text;
    [super viewWillUnload];
    
}
- (void)viewDidUnload
{

    [self setTxfName:nil];
    [self setTxfPassword:nil];
    [self setTxfPhone:nil];
    [self setTxfConfirmPassword:nil];
    [self setScrollview:nil];
    [self setImgViewAvatar:nil];
    [self setBtnRegister:nil];
    [self setLabelFirstName:nil];
    [self setLabelReentrePassword:nil];
    [self setLabelPhoneNumber:nil];
    [self setBtnBackground:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark UITextFieldDelegate
//implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:txfPhone]) {
        [txfPhone setKeyboardType:UIKeyboardTypePhonePad];
    }
    [scrollview setContentSize:self.view.frame.size];
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollview];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 15;
    [scrollview setContentOffset:pt animated:YES];
    _btnBackground.enabled=YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [scrollview setContentSize:self.view.frame.size];
    [scrollview setContentOffset:_svos animated:YES];
    [textField resignFirstResponder];
    _btnBackground.enabled=NO;
    return YES;
}


#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {

        default:
            break;
    }
}


- (void)postAPIUserCreatePhone {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            txfPhone.text,@"phone" ,
                            txfPassword.text,@"password",
                            txfName.text,@"name",
                            nil];
    NSLog(@"%@",params);
    [[AFAppDotNetAPIClient sharedClient] postPath:@"http://anuong.hehe.vn/api/user/createPhone" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        NSLog(@"%ld",(long)operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld",(long)operation.response.statusCode);
    }];
}

#pragma mark IBAction
-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)userRegisterClicked:(id)sender {
    [scrollview setContentSize:self.view.frame.size];
    [scrollview setContentOffset:_svos animated:YES];
    [self.view endEditing:YES];
    if ([Ultilities validateString:txfName.text]) {
        if ([Ultilities validatePhone:txfPhone.text]) {
            if ([Ultilities validatePassword:txfPassword.text withConfirmPass:txfConfirmPassword.text]){
                [self postAPIUserCreatePhone];
            }
        }else
            [Ultilities showAlertWithMessage:@"Xin dien sdt chinh xac"];
        
    }else
        [Ultilities showAlertWithMessage:@"Xin điền đúng thông tin ho ten"];
}



- (IBAction)getPhotoUserButtonClicked:(id)sender {
    [[SDImageCache sharedImageCache] clearMemory];

}

- (IBAction)backgroundButtonClicked:(id)sender {
    [scrollview setContentSize:self.view.frame.size];
    [scrollview setContentOffset:_svos animated:YES];
    _btnBackground.enabled=NO;
    [self.view endEditing:TRUE];
}

@end