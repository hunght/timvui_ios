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
    
    
    
    [self initKeyboardControls];
    
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar dropShadowWithOffset:CGSizeMake(0, 5) radius:5 color:[UIColor blackColor] opacity:1];
    if (!_branch)  self.navigationItem.leftBarButtonItem = self.toggleBarButtonItem;
    self.navigationItem.rightBarButtonItem = [self backBarButtonItem];
    
    // Generate Infomation Of Branch
    UIView *genarateInfoView=[[UIView alloc] initWithFrame:CGRectMake(5, 10, 310, 80)];
    [genarateInfoView setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=genarateInfoView.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    [(UIScrollView*)_scrollView addSubview:genarateInfoView];
    
    _lblBranchName = [[UILabel alloc] initWithFrame:CGRectMake(9, 9, 230, 20)];
    _lblBranchName.backgroundColor = [UIColor clearColor];
    _lblBranchName.textColor = [UIColor redColor];
    _lblBranchName.font = [UIFont fontWithName:@"UVNVanBold" size:(15)];
    
    [genarateInfoView addSubview:_lblBranchName];
    
    UIImage *imageDirection=[UIImage imageNamed:@"img_direction_icon"];
    UIImageView* imgDirectionView=[[UIImageView alloc] initWithFrame:CGRectMake(257,9+8 , 9, 9)];
    [imgDirectionView setImage:imageDirection];
    [genarateInfoView addSubview:imgDirectionView];
    
    _lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(270,9+4, 60, 15)];
    _lblDistance.backgroundColor = [UIColor clearColor];
    _lblDistance.textColor = [UIColor redColor];
    _lblDistance.font = [UIFont fontWithName:@"ArialMT" size:(15)];
    
    [genarateInfoView addSubview:_lblDistance];
    
    _lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(8.0+15, 35.0, 210, 12)];
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
    
    
    CGRect frame=self.view.frame;
    frame.origin.y-=genarateInfoView.frame.size.height;
    [(UIScrollView*)_scrollView setFrame:frame];
    [self.view setBackgroundColor:[UIColor colorWithRed:(239/255.0f) green:(239/255.0f) blue:(239/255.0f) alpha:1.0f]];
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
    _lblBranchName.text=_branch.name;
    double distance=[[GlobalDataUser sharedAccountClient] distanceFromAddress:_branch.latlng];
    if (distance>1000.0) {
        NSLog(@"%f",distance/1000.0);
        _lblDistance.text=[NSString stringWithFormat:@"%.2f km",distance/1000];
    }
    else
        _lblDistance.text=[NSString stringWithFormat:@"%f m",distance];
    _lblAddress.text=_branch.address_full;
    _lblPrice.text=_branch.price_avg;
    UIView* view=(UIView*)_scrollView;
    view.transform=CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.transform=CGAffineTransformMakeTranslation(0, 85);
    } completion:^(BOOL finished){
        
    }];
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
        if(_slidingViewController.underRightViewController)[self.slidingViewController anchorTopViewTo:ECRight];
    }
}

- (UIBarButtonItem *)toggleBarButtonItem {
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-off"] forState:UIControlStateHighlighted];
    //    [backButton addTarget:self.viewDeckController action:@selector(toggleDownLeftView) forControlEvents:UIControlEventTouchDown];
    [backButton addTarget:self action:@selector(toggleTopView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    item.accessibilityLabel = NSLocalizedString(@"Menu", nil);
    item.accessibilityHint = NSLocalizedString(@"Double-tap to reveal menu on the left. If you need to close the menu without choosing its item, find the menu button in top-right corner (slightly to the left) and double-tap it again.", nil);
    return item;
}

- (UIBarButtonItem *)backBarButtonItem {
    UIButton* doneButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 56, 29)];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"img_search_view_done_button"] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"img_search_view_done_button_on"] forState:UIControlStateHighlighted];
    [doneButton setTitle:@"Đóng" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:@"UVNVanBold" size:(15)];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    return doneButtonItem;
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


#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:NO];
}


@end
