#import "TVCoupon.h"
#import "GHUser.h"
#import "TVComment.h"
#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"


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

- (BOOL)isCommentEvent {
	return [self.name hasSuffix:@"CommentEvent"];
}

- (void)setValues:(id)dict {
	self.couponID = [dict safeStringForKey:@"id"];
	self.name = [dict safeStringForKey:@"name"];
	self.view   = [dict safeIntegerForKey:@"view"];
	self.used = [dict safeStringForKey:@"used"];
    self.code  =[dict safeStringForKey:@"code"];
    
    self.start = [dict safeDateForKey:@"start"];
	self.end = [dict safeDateForKey:@"end"];

    
}



- (NSString *)shortenRef:(NSString *)longRef {
	return [longRef lastPathComponent];
}

@end
