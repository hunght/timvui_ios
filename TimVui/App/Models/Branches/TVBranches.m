#import "TVBranches.h"
#import "TVBranch.h"
#import "NSDictionary+Extensions.h"

@implementation TVBranches

@synthesize resourcePath = _resourcePath;


- (void)setResourcePath:(NSString *)path {
	_resourcePath = path;
}

- (void)setValues:(id)values {
    if (values == [NSNull null])return;
    
    NSArray* arr=(_isNotSearchAPIYES) ? values:[values safeArrayForKey:@"items"];
    
//    if (_isNotSearchAPIYES) {
//        arr=values;
//    }
    
	self.items = [NSMutableArray array];

	for (NSDictionary *dict in arr) {
		TVBranch *branch = [[TVBranch alloc] initWithDict:dict];
        
		[self addObject:branch];
	}
	self.lastUpdate = [NSDate date];
}

@end