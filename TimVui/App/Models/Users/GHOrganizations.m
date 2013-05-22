#import "GHOrganizations.h"
#import "GHOrganization.h"
#import "GHUser.h"
#import "TVAppDelegate.h"
#import "NSDictionary+Extensions.h"


@implementation GHOrganizations

- (id)initWithUser:(GHUser *)user andPath:(NSString *)path {
	self = [super initWithPath:path];
	if (self) {
		self.user = user;
	}
	return self;
}

- (void)setValues:(id)values {
	self.items = [NSMutableArray array];
	for (NSDictionary *dict in values) {
        GHOrganization *org=nil;
            [org setValues:dict];
            [self addObject:org];
	}
	[self sortUsingSelector:@selector(compareByName:)];
}

@end