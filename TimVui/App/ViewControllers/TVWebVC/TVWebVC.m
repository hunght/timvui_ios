//
//  TVWebVC.m
//  Anuong
//
//  Created by Hoang The Hung on 10/1/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVWebVC.h"
#import "TVNetworkingClient.h"
#import "AFHTTPRequestOperation.h"
@interface TVWebVC ()

@end

@implementation TVWebVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRequest:(NSString*)requestStr
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableURLRequest* request=[[TVNetworkingClient sharedClient] requestWithMethod:@"POST" path:requestStr parameters:nil];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request] ;
        [operation setCompletionBlockWithSuccess:
         ^(AFHTTPRequestOperation *operation,
           id responseObject) {
             NSString *response = [operation responseString];
//             NSLog(@"response: [%@]",response);
             [_webView loadHTMLString:response baseURL:nil];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error: %@", [operation error]);
             
         }];
        
        //call start on your request operation
        [operation start];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
