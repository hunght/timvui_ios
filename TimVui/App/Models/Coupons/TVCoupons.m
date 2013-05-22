#import "TVCoupons.h"
#import "TVCoupon.h"


@implementation TVCoupons

@synthesize resourcePath = _resourcePath;

- (id)initWithPath:(NSString *)path{
	self = [super initWithPath:path];
	if (self) {
	}
	return self;
}

- (void)setResourcePath:(NSString *)path {
	_resourcePath = path;
}

- (void)setValues:(id)values {
	[self setValuesNoItemsQuotes:[values valueForKey:@"items"]];
}

- (void)setValuesNoItemsQuotes:(id)values {
	self.items = [NSMutableArray array];
	for (NSDictionary *dict in values) {
		TVCoupon *event = [[TVCoupon alloc] initWithDict:dict];
		[self addObject:event];
	}
	self.lastUpdate = [NSDate date];
}

@end