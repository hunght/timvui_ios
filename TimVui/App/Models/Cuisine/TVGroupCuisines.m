#import "TVGroupCuisines.h"
#import "TVCuisine.h"
#import "NSDictionary+Extensions.h"

@implementation TVGroupCuisines

- (id)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValues:dict];
	}
	return self;
}


- (void)setValues:(id)values {
    NSLog(@"%@",values);
    self.name = [values safeStringForKey:@"group"];
    self.items = [NSMutableArray array];
	for (NSDictionary *dict in [values valueForKey:@"items"] ) {
		TVCuisine *event = [[TVCuisine alloc] initWithDict:dict];
		[self.items addObject:event];
	}
}

@end