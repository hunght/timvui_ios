#import "TVCuisine.h"
#import "GHUser.h"
#import "TVComment.h"
#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"


@interface TVCuisine ()
@property(nonatomic,readwrite)BOOL read;
@end


@implementation TVCuisine

- (id)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		self.read = NO;
		[self setValues:dict];
	}
	return self;
}

- (void)markAsRead {
	self.read = YES;
}

- (void)setValues:(id)dict {
    NSLog(@"%@",dict);
	self.name = [dict safeStringForKey:@"name"];
	self.price   = [dict safeStringForKey:@"price"];
	self.price_old = [dict safeStringForKey:@"price_old"];

}

@end
