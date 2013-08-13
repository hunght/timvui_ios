#import "TVEvents.h"
#import "TVEvent.h"


@implementation TVEvents

@synthesize resourcePath = _resourcePath;

- (id)initWithPath:(NSString *)path{
	self = [super initWithPath:path];
	if (self) {
	}
	return self;
}

- (void)setValues:(id)values {
	self.items = [NSMutableArray array];

    
	for (NSDictionary *dict in values) {
        
		TVEvent *branch = [[TVEvent alloc] initWithDict:dict];
        
		[self addObject:branch];
	}
}

@end