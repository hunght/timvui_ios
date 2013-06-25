#import "TVComments.h"
#import "TVComment.h"


@implementation TVComments


- (void)setValues:(id)values {
	self.items = [NSMutableArray array];
    NSLog(@"%@",values);
	for (NSDictionary *dict in values ) {
		TVComment *branch = [[TVComment alloc] initWithDict:dict];
		[self addObject:branch];
	}
}

@end