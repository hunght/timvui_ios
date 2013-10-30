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
#import "GAI.h"
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
        NSArray *array = [coupon.sms_type allKeys];
        if (array.count==1) {
            NSString* strSMSCode = array.lastObject;
//            NSString* strNumberUser=  [coupon.sms_type objectForKey:strSMSCode];
            NSString* titleMess=[NSString stringWithFormat:@"Soạn Coupon %@ gửi 8%@88 để nhận mã Coupon này",coupon.syntax,strSMSCode];
            
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Nhận mã coupon" andMessage:titleMess];

            [alertView addButtonWithTitle:@"OK"
                                         type:SIAlertViewButtonTypeDefault
                                      handler:^(SIAlertView *alert) {
                                          [TVSMSVC sendSMSWithCoupon:coupon andOption:strSMSCode andViewController:viewController];
                                      }];

            
            [alertView addButtonWithTitle:@"Bỏ qua"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alert) {
                                      NSLog(@"Cancel Clicked");
                                  }];
            [alertView show];
        }else{
            
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Nhận mã coupon" andMessage:nil];
            array = [array sortedArrayUsingSelector: @selector(compare:)];
            
            for (NSString* strSMSCode in array) {
                NSString* strNumberUser=  [coupon.sms_type objectForKey:strSMSCode];
                NSString* titleMess=[NSString stringWithFormat:@"%@ mã coupon (%@ người dùng)",strNumberUser,strNumberUser];
                [alertView addButtonWithTitle:titleMess
                                         type:SIAlertViewButtonTypeDefault
                                      handler:^(SIAlertView *alert) {
                                          [TVSMSVC sendSMSWithCoupon:coupon andOption:strSMSCode andViewController:viewController];
                                      }];
            }
            [alertView addButtonWithTitle:@"Bỏ qua"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alert) {
                                      NSLog(@"Cancel Clicked");
                                  }];
            [alertView show];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    #warning GAI tracking not done
    
//    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Chi tiết branch"
//                                                     withAction:@"Chi tiết branch- Gửi SMS nhận coupon"
//                                                      withLabel:@"Chi tiết branch- Gửi SMS nhận coupon"
//                                                      withValue:[NSNumber numberWithInt:0]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
