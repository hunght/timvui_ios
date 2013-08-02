//
//  DetailManualVC.m
//  Anuong
//
//  Created by Hoang The Hung on 7/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "DetailManualVC.h"
#import "TVNetworkingClient.h"
#import "GlobalDataUser.h"
#import "NSDictionary+Extensions.h"
#import <QuartzCore/QuartzCore.h>
#import "TVManual.h"
#import "TVCoupon.h"
#import "TVCoupons.h"
#import "TSMessage.h"
#import "BranchMainCell.h"
#import "TVBranch.h"
#import "TVAppDelegate.h"
#import "BranchProfileVC.h"
@interface DetailManualVC (){

@private
    TVManual* _manual;

}
@end

@implementation DetailManualVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withManual:(TVManual*)manual
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _manual=manual;
        _branches=[[TVBranches alloc] initWithPath:@"branch/getById"];
        _branches.isNotSearchAPIYES=YES;
    }
    return self;
}

-(void)postGetBranches{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _manual.branch_ids,@"id" ,
                            nil];
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    
    [weakSelf.branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            //NSLog(@"weakSelf.branches.count===%@",[weakSelf.branches[0] name]);
            [self.tableView reloadData];
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
            
        });
    }];
}
-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    _couponBranch=[[UIView alloc] initWithFrame:CGRectMake(6, 6, 320-6*2, 200)];
    [_couponBranch setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=_couponBranch.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(10.0, 5, 300, 23)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor redColor];
    lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
    lblTitle.numberOfLines = 0;
    lblTitle.lineBreakMode = UILineBreakModeWordWrap;
    [_couponBranch addSubview:lblTitle];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    UIWebView* webView=[[UIWebView alloc] initWithFrame:CGRectMake(6+5, 0, 320-(6+5)*2, 200)];
    [webView.scrollView setScrollEnabled:NO];
    [_couponBranch addSubview:webView];
    lblTitle.text=_manual.title;
    [lblTitle sizeToFit];
    int height=lblTitle.frame.origin.y+lblTitle.frame.size.height;
    
    CGRect frame=webView.frame;
    frame.origin.y=height+5;
    [webView setFrame:frame];
    [webView setDelegate:self];
    [webView sizeToFit];
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    //    NSLog(@"%@",_coupon.content);
    //continue building the string
    [html appendString:_manual.content];
    [html appendString:@"</body></html>"];
    [webView loadHTMLString:html baseURL:nil];
    [self.view insertSubview:_couponBranch belowSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL* url = [request URL];
    if ([[url scheme] isEqualToString:@"native"]) {
        if ([[url host] isEqualToString:@"imageclick"]) {
//            if (self.imageClick) {
//                self.imageClick([self.imgURLforHash objectForKey:[url query]]);
//            }
        }
    } else {
        if ([[url absoluteString] isEqualToString:@"about:blank"]) {
            return YES;
        } else if ([[url scheme] isEqualToString:@"file"]) {
            return YES;
        } else if ([[url host] isEqualToString:@"www.youtube.com"]) {
            return YES;
        } else if ([[url host] isEqualToString:@"player.vimeo.com"]) {
            return YES;
        } else if ([url.absoluteString rangeOfString:@"src=http://www.youtube"].location != NSNotFound) {
            //http://reader.googleusercontent.com/reader/embediframe?src=http://www.youtube.com/v/4OD770n60cA?version%3D3%26hl%3Dpt_BR&width=640&height=360
            return NO;
        } else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//            if (self.urlClick) {
//                self.urlClick([url absoluteString]);
//            }
        } else if (navigationType == UIWebViewNavigationTypeOther) {
            NSLog(@"Deny load url from UIWebView - %@", [url absoluteString]);
            return NO;
        }
    }
    
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.alpha = 1;
    }];
    
    CGRect newBounds = webView.frame;
    newBounds.size.height = webView.scrollView.contentSize.height+50;
    webView.frame = newBounds;
    
    int height_p=webView.frame.origin.y+webView.frame.size.height+10;
    
    CGRect frame=_couponBranch.frame;
    frame.size.height=height_p;
    _couponBranch.frame=frame;
    self.tableView.tableHeaderView = _couponBranch;
    [self postGetBranches];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.branches count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    BranchMainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BranchMainCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else{
        [[cell.utility subviews]  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    double distance=[[GlobalDataUser sharedAccountClient] distanceFromAddress:[self.branches[indexPath.row]latlng]];
    [cell setBranch:self.branches[indexPath.row] withDistance:distance];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BranchMainCell heightForCellWithPost:self.branches[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    BranchProfileVC* branchProfileVC=[[BranchProfileVC alloc] initWithNibName:@"BranchProfileVC" bundle:nil];
    branchProfileVC.branchID=[_branches[indexPath.row] branchID];
    [self.navigationController pushViewController:branchProfileVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
