//
//  CommentVC.h
//  TimVui
//
//  Created by Hoang The Hung on 6/26/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "LocationTableVC.h"
#import "BSKeyboardControls.h"
#import "UIPlaceHolderTextView.h"
@class TPKeyboardAvoidingScrollView;
@interface CommentVC : UIViewController<UITextViewDelegate,LocationTableVCDelegate,BSKeyboardControlsDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switchFacebook;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectLocation;
- (IBAction)selectLocationButtonClicked:(id)sender;
@property(nonatomic, assign)ECSlidingViewController *slidingViewController;
@property (nonatomic, strong)UILabel *lblBranchName;
@property (nonatomic, strong)UILabel *lblAddress;
@property (nonatomic, strong)UILabel *lblPrice;
@property (nonatomic, strong)TVBranch *branch;
@property (nonatomic, strong)NSNumber * rating;
@property (unsafe_unretained, nonatomic) IBOutlet UIPlaceHolderTextView *txvContent;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnCommentPost;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *firstStar;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *secondStar;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *thirdStar;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *fourthStar;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *fifthStar;
- (IBAction)starButtonClicked:(id)sender;
- (IBAction)postFacebookSwitchValueChanged:(id)sender;
- (IBAction)postCommentButtonClicked:(id)sender;

@end
