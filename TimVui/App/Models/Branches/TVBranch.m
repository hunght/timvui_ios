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
    
//    self.coupons = [[TVCoupons alloc] init];
//	[self.coupons   setValues:[[dict safeDictForKey:@"coupons"] allValues]];
    
	self.special_content = [dict safeArrayForKey:@"special_content"];
	self.address_full = [dict safeStringForKey:@"address_full"];
	self.latlng = [dict safeLocationForKey:@"latlng"];
    
    self.image_count=[dict safeIntegerForKey:@"image_count"];
    self.images = [dict safeArrayForKey:@"images"];
    self.phone = [dict safeStringForKey:@"phone"];
    self.cats = [dict safeDictForKey:@"cats"];
    self.district = [dict safeDictForKey:@"district"];
        
    self.space = [dict safeStringForKey:@"space"];
    self.time_open = [dict safeStringForKey:@"time_open"];
    
    self.waiting_start = [dict safeStringForKey:@"waiting_start"];
    self.waiting_end = [dict safeStringForKey:@"waiting_end"];
    self.holiday = [dict safeStringForKey:@"holiday"];
    self.year = [dict safeStringForKey:@"year"];
    
    self.adaptive = [[[dict valueForKey:@"params"] valueForKey:@"thich-hop"] safeDictForKey:@"params"];
    self.styleFoody = [[[dict valueForKey:@"params"] valueForKey:@"am-thuc"] safeDictForKey:@"params"];
    self.services = [[[dict valueForKey:@"params"] valueForKey:@"tien-ich"] safeDictForKey:@"params"];
    self.purpose = [[[dict valueForKey:@"params"] valueForKey:@"muc-dich"] safeDictForKey:@"params"];
    self.decoration = [[[dict valueForKey:@"params"] valueForKey:@"khong-gian"] safeDictForKey:@"params"];
    self.cuisine = [[[dict valueForKey:@"params"] valueForKey:@"mon-an"] safeDictForKey:@"params"];
    
    self.space = [dict safeStringForKey:@"space"];
    self.direction = [dict safeStringForKey:@"direction"];
    self.public_locations = [dict safeDictForKey:@"public_locations"];
    
    self.time_close =[dict safeStringForKey:@"time_close"];
}



- (NSString *)shortenRef:(NSString *)longRef {
	return [longRef lastPathComponent];
}

@end
