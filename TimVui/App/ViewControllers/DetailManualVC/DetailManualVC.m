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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView* couponBranch=[[UIView alloc] initWithFrame:CGRectMake(6, 6, 320-6*2, 360)];
    [couponBranch setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=couponBranch.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    [self.view addSubview:couponBranch];
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(10.0, 5, 300, 23)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor redColor];
    lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
    lblTitle.numberOfLines = 0;
    lblTitle.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:lblTitle];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    UIWebView* webView=[[UIWebView alloc] initWithFrame:CGRectMake(6+5, 0, 320-(6+5)*2, 270)];
    [webView.scrollView setScrollEnabled:NO];
    [couponBranch addSubview:webView];
    lblTitle.text=_manual.title;
    [lblTitle sizeToFit];
    int height=lblTitle.frame.origin.y+lblTitle.frame.size.height;
    
    CGRect frame=webView.frame;
    frame.origin.y=height+5;
    [webView setFrame:frame];
    
    [webView loadHTMLString:_manual.content baseURL:nil];
    [webView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
