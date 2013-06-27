//
//  RegisterViewController.h
//  CityOffers
//
//  Created by Nguyen Mau Dat on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroApp.h"
#import "Ultilities.h"

#import "GAITrackedViewController.h"
@class TPKeyboardAvoidingScrollView;

@interface UserRegisterVC : GAITrackedViewController<UITextFieldDelegate>{
    NSString*   user_email;
    NSString*  user_firstName;
    NSString*  user_lastName;
    NSString*  user_password;
    NSString*  user_confirm_password;
    NSString*  user_phone;
    BOOL _isTakenPhotoYES;
    NSURL* urlImage;
}
@property (unsafe_unretained, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollview;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnRegister;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txfPassword;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txfPhone;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txfConfirmPassword;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn_Cancel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txfName;


//IBAction
- (IBAction)userRegisterClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
