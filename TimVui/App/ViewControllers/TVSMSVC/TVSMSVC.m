//
//  TVSMSVC.m
//  Anuong
//
//  Created by Hoang The Hung on 10/8/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVSMSVC.h"
#import "TVCoupon.h"
#import "MacroApp.h"
#import "SIAlertView.h"
@interface TVSMSVC ()

@end

@implementation TVSMSVC
-(id)initWithCoupon:(TVCoupon*)coupon andOption:(NSString*)optionNum{
    if ((self = [super init]))
    {
        self.body = [NSString stringWithFormat:@"coupon %@",coupon.syntax];
        self.recipients = [NSArray arrayWithObjects:[NSString stringWithFormat:SMS_NUMBER,optionNum], nil];
    }
    return self;
}

+ (void)sendSMSWithCoupon:(TVCoupon *)coupon andOption:(NSString*)strSMSCode andViewController:(id)viewController {
    
    TVSMSVC *picker = [[TVSMSVC alloc] initWithCoupon:coupon andOption:strSMSCode];
    picker.messageComposeDelegate = viewController;
    UIViewController*vc=(UIViewController*)viewController;
    [vc.navigationController    presentModalViewController:picker animated:YES];
}

+(void)viewOptionSMSWithViewController:(UIViewController*)viewController andCoupon:(TVCoupon*)coupon{
    if([TVSMSVC canSendText]) {
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Nhận mã coupon" andMessage:@"Soạn Coupon ABCD gửi 8x88 để nhận mã Coupon này"];
        NSArray *array = [coupon.sms_type allKeys];
        array = [array sortedArrayUsingSelector: @selector(compare:)];
        for (NSString* strSMSCode in array) {
            NSString* strNumberUser=  [coupon.sms_type objectForKey:strSMSCode];
            NSString* titleMess=[NSString stringWithFormat:@"Nhận %@ mã coupon (%@ người dùng)",strNumberUser,strNumberUser];
            [alertView addButtonWithTitle:titleMess
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alert) {
                                      [TVSMSVC sendSMSWithCoupon:coupon andOption:strSMSCode andViewController:viewController];
                                  }];
        }
        [alertView addButtonWithTitle:@"Cancel"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  NSLog(@"Cancel Clicked");
                              }];
        [alertView show];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Chi tiết branch"
                                                     withAction:@"Chi tiết branch- Gửi SMS nhận coupon"
                                                      withLabel:@"Chi tiết branch- Gửi SMS nhận coupon"
                                                      withValue:[NSNumber numberWithInt:0]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
