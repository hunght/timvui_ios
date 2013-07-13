#import "TVBranches.h"
#import "TVBranch.h"


@implementation TVBranches

@synthesize resourcePath = _resourcePath;

- (id)initWithPath:(NSString *)path account:(GHAccount *)account {
	self = [super initWithPath:path];
	if (self) {
	}
	return self;
}


- (void)setResourcePath:(NSString *)path {
	_resourcePath = path;
}

- (void)setValues:(id)values {
    NSArray* arr=(_isNotSearchAPIYES)?values:[values valueForKey:@"items"];
	self.items = [NSMutableArray array];

    
	for (NSDictionary *dict in arr) {
        
		TVBranch *branch = [[TVBranch alloc] initWithDict:dict];
        
		[self addObject:branch];
	}
	self.lastUpdate = [NSDate date];
}

@end