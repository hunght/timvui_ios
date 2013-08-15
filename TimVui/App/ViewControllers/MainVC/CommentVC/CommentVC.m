//
//  CommentVC.m
//  TimVui
//
//  Created by Hoang The Hung on 6/26/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "CommentVC.h"
#import "UINavigationBar+JTDropShadow.h"
#import "GlobalDataUser.h"
#import "TVNetworkingClient.h"
#import "TSMessage.h"
#import "Utilities.h"

@interface CommentVC ()
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation CommentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)initKeyboardControls
{
    NSArray *fields = @[ self.txvContent];
    
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setVisibleControls:BSKeyboardControlDone];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _bgView.backgroundColor =[UIColor colorWithWhite:0.0 alpha:0.7];
    _btnSelectLocation.titleLabel.font=[UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    [_btnSelectLocation setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(3/255.0f) green:(190/255.0f) blue:(239/255.0f) alpha:1.0f]] forState:UIControlStateNormal];
    
    [_btnSelectLocation setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(71/255.0f) green:(217/255.0f) blue:(255/255.0f) alpha:1.0f]] forState:UIControlStateSelected];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [_txvContent setPlaceholder:@"Viết đánh giá về địa điểm này"];
    
    [self initKeyboardControls];
    
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar dropShadow];
    if (!_branch)  self.navigationItem.leftBarButtonItem = self.toggleBarButtonItem;
    [self backBarButtonItem];
    
    UIView *bgGenarateInfoView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [bgGenarateInfoView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
    
    UIView *bgGreenInfoView=[[UIView alloc] initWithFrame:CGRectMake(0, 100-3, 320, 3)];
    [bgGreenInfoView setBackgroundColor:[UIColor colorWithRed:(3/255.0f) green:(190/255.0f) blue:(239/255.0f) alpha:1.0f]];
    [bgGenarateInfoView addSubview:bgGreenInfoView];
    
    // Generate Infomation Of Branch
    UIView *genarateInfoView=[[UIView alloc] initWithFrame:CGRectMake(5, 10, 310, 85)];
    [self.scrollView  insertSubview:bgGenarateInfoView belowSubview:genarateInfoView];
    
    [genarateInfoView setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=genarateInfoView.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:1.0];
    // You can even add a border
    
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    [(UIScrollView*)_scrollView addSubview:genarateInfoView];
    l=_txvContent.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:3.0];
    // You can even add a border
    
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    
    _lblBranchName = [[UILabel alloc] initWithFrame:CGRectMake(9, 9, 230, 20)];
    _lblBranchName.backgroundColor = [UIColor clearColor];
    _lblBranchName.textColor = [UIColor blackColor];
    _lblBranchName.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    
    [genarateInfoView addSubview:_lblBranchName];
    
    _lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(8.0+15, 35.0, 270, 12)];
    _lblAddress.backgroundColor = [UIColor clearColor];
    _lblAddress.textColor = [UIColor grayColor];
    _lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    
    [genarateInfoView addSubview:_lblAddress];
    
    _lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(8.0+15, 53.0, 210, 12)];
    _lblPrice.backgroundColor = [UIColor clearColor];
    _lblPrice.textColor = [UIColor grayColor];
    _lblPrice.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    
    [genarateInfoView addSubview:_lblPrice];
    
    UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 35.0, 11, 12)];
    homeIcon.image=[UIImage imageNamed:@"img_address_branch_icon"];
    [genarateInfoView addSubview:homeIcon];
    
    UIImageView* price_avgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 53.0, 8, 11)];
    price_avgIcon.image=[UIImage imageNamed:@"img_price_range_branch_icon"];
    [genarateInfoView addSubview:price_avgIcon];
    
    
    l=_txvContent.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5];
    [_btnCommentPost setBackgroundImage:[UIImage imageNamed:@"img_button_big_on"] forState:UIControlStateHighlighted];
    
    if (_branch)
        [self displayBranchInfo];
    
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setFirstStar:nil];
    [self setSecondStar:nil];
    [self setThirdStar:nil];
    [self setFourthStar:nil];
    [self setFifthStar:nil];
    [self setBtnCommentPost:nil];
    [self setTxvContent:nil];
    [self setBgView:nil];
    [self setBtnSelectLocation:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneButtonClicked:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - LocationTableVCDelegate
- (void)displayBranchInfo {
    if (!_bgView.isHidden) _bgView.hidden=YES;
    _lblBranchName.text=_branch.name;
    _lblAddress.text=_branch.address_full;
    _lblPrice.text=_branch.price_avg;
}

-(void)didPickWithLoation:(TVBranch *)_branchProfile{
    [self toggleTopView];
    _branch=_branchProfile;
    [self displayBranchInfo];

}
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (_branch)
        return YES;
    else{
        return NO;
    }
}

#pragma mark IBAction

- (void)toggleTopView {
    if (self.slidingViewController.underLeftShowing) {
        // actually this does not get called when the top view screenshot is enabled
        // because the screenshot intercepts the touches on the toggle button
        [self.slidingViewController resetTopView];
    } else {
        [self.slidingViewController anchorTopViewTo:ECRight];
    }
}

- (UIBarButtonItem *)toggleBarButtonItem {
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-off"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-on"] forState:UIControlStateHighlighted];
    
    //[backButton addTarget:self.viewDeckController action:@selector(toggleDownLeftView) forControlEvents:UIControlEventTouchDown];
    [backButton addTarget:self action:@selector(toggleTopView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    item.accessibilityLabel = NSLocalizedString(@"Menu", nil);
    item.accessibilityHint = NSLocalizedString(@"Double-tap to reveal menu on the left. If you need to close the menu without choosing its item, find the menu button in top-right corner (slightly to the left) and double-tap it again.", nil);
    return item;
}

- (void)backBarButtonItem {
    UIButton* doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    
    [doneButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(245/255.0f) green:(77/255.0f) blue:(44/255.0f) alpha:1.0f]] forState:UIControlStateNormal];
    
    [doneButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(245/255.0f) green:(110/255.0f) blue:(44/255.0f) alpha:1.0f]] forState:UIControlStateHighlighted];
    
    [doneButton setTitle:@"ĐÓNG" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    backButtonView.bounds = CGRectOffset(backButtonView.bounds, -5, -0);
    [backButtonView addSubview:doneButton];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    self.navigationItem.rightBarButtonItem=doneButtonItem;
}

- (IBAction)starButtonClicked:(UIButton*)sender {
    _rating=[NSNumber numberWithInt:sender.tag];
    [_firstStar setImage:[UIImage imageNamed:(sender.tag>=1)?@"img_comment_star_on":@"img_comment_star_off"] forState:UIControlStateNormal];
    
    [_secondStar setImage:[UIImage imageNamed:(sender.tag>=2)?@"img_comment_star_on":@"img_comment_star_off"] forState:UIControlStateNormal];
    
    [_thirdStar setImage:[UIImage imageNamed:(sender.tag>=3)?@"img_comment_star_on":@"img_comment_star_off"] forState:UIControlStateNormal];
    
    [_fourthStar setImage:[UIImage imageNamed:(sender.tag>=4)?@"img_comment_star_on":@"img_comment_star_off"] forState:UIControlStateNormal];
    
    [_fifthStar setImage:[UIImage imageNamed:(sender.tag>=5)?@"img_comment_star_on":@"img_comment_star_off"] forState:UIControlStateNormal];
}

- (IBAction)postFacebookSwitchValueChanged:(id)sender {
    
}

- (IBAction)postCommentButtonClicked:(id)sender {
    if (_branch) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                                _branch.branchID,@"branch_id" ,
                                @"1",@"branch_id" ,
                                [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                                _txvContent.text,@"content" ,
                                [_rating stringValue],@"rating" ,
                                nil];
        [[TVNetworkingClient sharedClient] postPath:@"branch/postComment" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
            [TSMessage showNotificationInViewController:self
                                              withTitle:@"Đăng comment thành công"
                                            withMessage:nil
                                               withType:TSMessageNotificationTypeSuccess];
            [self dismissModalViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [TSMessage showNotificationInViewController:self
                                              withTitle:@"Đăng comment thất bại"
                                            withMessage:nil
                                               withType:TSMessageNotificationTypeError];
        }];
    }
}




- (IBAction)selectLocationButtonClicked:(id)sender {
    [self toggleTopView];
}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:NO];
}

@end
