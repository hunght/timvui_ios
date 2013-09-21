#import "TVComment.h"
#import "GHUser.h"
#import "GHUsers.h"
#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"


@implementation TVComment

- (id)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValues:dict];
	}
	return self;
}

- (void)setValues:(id)dict {
   	self.commentID = [dict safeStringForKey:@"id"];
    self.user_id = [dict safeStringForKey:@"user_id"];
	self.user_name = [dict safeStringForKey:@"user_name"];
	self.arrURLImages = [dict safeDictForKey:@"image"];
    
	self.content = [dict safeStringForKey:@"content"];
    self.like_count=[dict safeIntegerForKey:@"like_count"];
    self.rating=[dict safeIntegerForKey:@"rating"];
    self.created=[dict safeDateForKey:@"created"];
    NSLog(@"self.create %@",self.created);
}

#pragma mark Associations





@end