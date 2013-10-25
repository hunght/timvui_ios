#import "TVCoupon.h"
#import "GHUser.h"
#import "TVComment.h"
#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"
#import "GlobalDataUser.h"

@interface TVCoupon ()
@property(nonatomic,readwrite)BOOL read;
@end


@implementation TVCoupon

- (id)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		self.read = NO;
		[self setValues:dict];
	}
	return self;
}


- (void)markAsRead {
	self.read = YES;
}

- (void)setValues:(id)dict {
//    NSLog(@"%@",dict);
    
	self.couponID = [dict safeStringForKey:@"id"];
	self.name = [dict safeStringForKey:@"name"];
	self.view = [dict safeStringForKey:@"view"];
	self.used_number = [dict safeStringForKey:@"used_number"];
    self.use_number = [dict safeStringForKey:@"use_number"];
    self.syntax  =[dict safeStringForKey:@"syntax"];
    self.start = [dict safeDateForKey:@"start"];
	self.end = [dict safeDateForKey:@"end"];
    self.content = [dict safeStringForKey:@"content"];
    self.status = [dict safeStringForKey:@"status"];
    self.sms_type = [dict safeDictForKey:@"sms_type"];
    
    self.special_content = [dict safeStringForKey:@"special_content"];
    self.condition_content = [dict safeStringForKey:@"condition_content"];
    
    self.image=[dict safeDictForKey:@"image"];
    int count=[[GlobalDataUser sharedAccountClient].couponImpressionArr safeIntegerForKey:self.couponID];
    
    [[GlobalDataUser sharedAccountClient].couponImpressionArr setValue:[NSString stringWithFormat:@"%d",count+1] forKey:self.couponID];
}

@end
