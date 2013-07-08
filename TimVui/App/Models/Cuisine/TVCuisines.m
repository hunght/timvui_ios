#import "TVCuisines.h"
#import "TVGroupCuisines.h"


@implementation TVCuisines

- (void)setValues:(id)values {
    NSLog(@"%@",values);
    self.items = [NSMutableArray array];
	for (NSDictionary *dict in [[values valueForKey:@"groups"] allValues]) {
		TVGroupCuisines *event = [[TVGroupCuisines alloc] initWithDict:dict];
		[self.items addObject:event];
	}
}

@end