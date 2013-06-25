#import "TVComments.h"
#import "TVComment.h"


@implementation TVComments


- (void)setValues:(id)values {
	self.items = [NSMutableArray array];
	for (NSDictionary *dict in [values valueForKey:@"data"]) {
		TVComment *branch = [[TVComment alloc] initWithDict:dict];
		[self addObject:branch];
	}
}

@end