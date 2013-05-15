#import "GHUsers.h"
#import "GHUser.h"
#import "AppDelegate.h"
#import "NSDictionary+Extensions.h"


@implementation GHUsers

- (void)setValues:(id)values {
	self.items = [NSMutableArray array];
	for (NSDictionary *dict in values) {
        GHUser *user = nil;

            [user setValues:dict];
            [self addObject:user];

	}
	[self sortUsingSelector:@selector(compareByName:)];
}

@end