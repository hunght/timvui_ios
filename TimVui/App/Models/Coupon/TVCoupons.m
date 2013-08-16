#import "TVCoupons.h"
#import "TVCoupon.h"


@implementation TVCoupons


- (void)setValues:(id)values {
    NSLog(@"%@",values);
    self.items = [NSMutableArray array];
	for (NSDictionary *dict in values) {
		TVCoupon *event = [[TVCoupon alloc] initWithDict:dict];
		[self.items addObject:event];
	}
}

@end