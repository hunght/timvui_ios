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
    
	self.items = [NSMutableArray array];
    NSArray* arr=[values valueForKey:@"items"];
    
	for (NSDictionary *dict in arr) {
        
		TVBranch *branch = [[TVBranch alloc] initWithDict:dict];
        
		[self addObject:branch];
	}
	self.lastUpdate = [NSDate date];
}

@end