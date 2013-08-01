#import "TVGroupCuisines.h"
#import "TVCuisine.h"
#import "NSDictionary+Extensions.h"

@implementation TVGroupCuisines

- (id)initWithDict:(NSArray *)dict {
	self = [super init];
	if (self) {
		[self setValues:dict];
	}
	return self;
}


- (void)setValues:(id)values {
    NSLog(@"TVGroupCuisines======%@",values);
    
    self.items = [NSMutableArray array];
	for (NSDictionary *dict in values ) {
		TVCuisine *event = [[TVCuisine alloc] initWithDict:dict];
		[self.items addObject:event];
	}
}

@end