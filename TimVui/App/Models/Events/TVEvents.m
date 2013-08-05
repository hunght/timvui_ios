#import "TVEvents.h"
#import "TVEvent.h"


@implementation TVEvents

@synthesize resourcePath = _resourcePath;


- (void)setResourcePath:(NSString *)path {
	_resourcePath = path;
}

- (void)setValues:(id)values {
	self.items = [NSMutableArray array];

    
	for (NSDictionary *dict in values) {
        
		TVEvent *branch = [[TVEvent alloc] initWithDict:dict];
        
		[self addObject:branch];
	}
}

@end