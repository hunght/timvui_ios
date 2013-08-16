#import "TVKaraokes.h"
#import "TVKaraoke.h"


@implementation TVKaraokes



- (void)setValues:(id)values {
	self.items = [NSMutableArray array];

    
	for (NSDictionary *dict in values) {
        
		TVKaraoke *branch = [[TVKaraoke alloc] initWithDict:dict];
        
		[self.items addObject:branch];
	}
}

@end