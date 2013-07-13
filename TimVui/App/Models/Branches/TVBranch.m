    #import "TVBranch.h"
#import "GHUser.h"
#import "TVComment.h"
#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"
#import "TVCoupons.h"
@interface TVBranch ()
@property(nonatomic,readwrite)BOOL read;
@end


@implementation TVBranch


- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_branchID forKey:@"branchID"];
    [coder encodeObject:_name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[TVBranch alloc] init];
    if (self != nil)
    {
        _branchID = [coder decodeObjectForKey:@"branchID"] ;
        _name = [coder decodeObjectForKey:@"name"] ;
    }
    return self;
}


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

- (BOOL)isCommentEvent {
	return [self.name hasSuffix:@"CommentEvent"];
}

- (void)setValues:(NSDictionary*)dict {
    NSLog(@"tvBranch===%@",dict);
	self.branchID = [dict safeStringForKey:@"id"];
	self.name = [dict safeStringForKey:@"name"];
    
    NSLog(@"self.name===%@",self.name);
	self.arrURLImages = [dict safeDictForKey:@"image"];
    
	self.price_avg = [dict safeStringForKey:@"price_avg"];
    self.coupon_count=[dict safeIntegerForKey:@"coupon_count"];
    
    self.coupons = [[TVCoupons alloc] init];
	[self.coupons   setValues:[dict safeArrayForKey:@"coupons"] ];
    
    self.menu = [[TVCuisines alloc] init];
	[self.menu   setValues:[dict safeDictForKey:@"items"] ];
    
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
    self.utilities = [dict safeArrayForKey:@"utilities"];
//    NSLog(@"%@",_utilities);
    self.adaptive = [[[dict safeDictForKey:@"params"] safeDictForKey:@"thich-hop"] safeDictForKey:@"params"];
    self.styleFoody = [[[dict safeDictForKey:@"params"] safeDictForKey:@"am-thuc"] safeDictForKey:@"params"];
    self.services = [[[dict safeDictForKey:@"params"] safeDictForKey:@"tien-ich"] safeDictForKey:@"params"];
    self.purpose = [[[dict safeDictForKey:@"params"] safeDictForKey:@"muc-dich"] safeDictForKey:@"params"];
    self.decoration = [[[dict safeDictForKey:@"params"] safeDictForKey:@"khong-gian"] safeDictForKey:@"params"];
    self.cuisine = [[[dict safeDictForKey:@"params"] safeDictForKey:@"mon-an"] safeDictForKey:@"params"];
    
    self.space = [dict safeStringForKey:@"space"];
    self.direction = [dict safeStringForKey:@"direction"];
    self.public_locations = [dict safeDictForKey:@"public_locations"];
    
    self.time_close =[dict safeStringForKey:@"time_close"];
    
    
}



- (NSString *)shortenRef:(NSString *)longRef {
	return [longRef lastPathComponent];
}

@end
