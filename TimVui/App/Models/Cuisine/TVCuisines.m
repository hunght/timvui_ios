#import "TVCuisines.h"
#import "TVGroupCuisines.h"
#import "NSDictionary+Extensions.h"

@implementation TVCuisines

- (void)setValues:(id)values {
    NSLog(@"TVCuisines====%@",values);
    self.count=[values safeIntegerForKey:@"count"];
    self.items = [NSMutableArray array];
	for (NSString*key in [values allKeys]) {
        
		TVGroupCuisines *event = [[TVGroupCuisines alloc] initWithDict:[values safeArrayForKey:key]];
        event.name = key;
		[self.items addObject:event];
	}
}

@end