//
//  TVWebVC.h
//  Anuong
//
//  Created by Hoang The Hung on 10/1/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVWebVC : UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRequest:(NSString*)requestStr;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* requestStr;
@end
