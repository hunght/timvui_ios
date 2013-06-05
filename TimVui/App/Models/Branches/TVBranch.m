#import "TVBranch.h"
#import "GHUser.h"
#import "GHOrganization.h"
#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"
#import "TVCoupons.h"
@interface TVBranch ()
@property(nonatomic,readwrite)BOOL read;
@end


@implementation TVBranch

- (id)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		self.read = NO;
		[self setValues:dict];
	}
	return self;
}

- (NSString *)extendedEventType {
	NSString *action = [self.arrURLImages safeStringForKey:@"action"];
	if ([self.name isEqualToString:@"IssuesEvent"]) {
		return [action isEqualToString:@"closed"] ? @"IssuesClosedEvent" : @"IssuesOpenedEvent";
	} else if ([self.name isEqualToString:@"PullRequestEvent"]) {
		if ([action isEqualToString:@"synchronize"]) {
			return @"PullRequestSynchronizeEvent";
		}
		return [action isEqualToString:@"closed"] ? @"PullRequestClosedEvent" : @"PullRequestOpenedEvent";
	}
	return self.name;
}

- (void)markAsRead {
	self.read = YES;
}

- (BOOL)isCommentEvent {
	return [self.name hasSuffix:@"CommentEvent"];
}

- (void)setValues:(id)dict {
	self.branchID = [dict safeStringForKey:@"id"];
	self.name = [dict safeStringForKey:@"name"];
	self.arrURLImages = [dict safeDictForKey:@"image"];
    
	self.price_avg = [dict safeStringForKey:@"price_avg"];
    self.coupon_count=[dict safeIntegerForKey:@"coupon_count"];
    
    self.coupons = [[TVCoupons alloc] init];
	[self.coupons   setValues:[[dict safeDictForKey:@"coupons"] allValues]];
    
	self.special_content = [dict safeStringForKey:@"special_content"];
	self.address_full = [dict safeStringForKey:@"address_full"];
	self.latlng = [dict safeLocaitonForKey:@"latlng"];
}



- (NSString *)shortenRef:(NSString *)longRef {
	return [longRef lastPathComponent];
}

@end
