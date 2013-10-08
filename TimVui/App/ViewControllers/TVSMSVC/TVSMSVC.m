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
@interface TVSMSVC ()

@end

@implementation TVSMSVC
-(id)initWithCoupon:(TVCoupon*)coupon andOption:(int)optionNum{
    if ((self = [super init]))
    {
        self.body = [NSString stringWithFormat:@"coupon %@",coupon.syntax];
        self.recipients = [NSArray arrayWithObjects:SMS_NUMBER, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
