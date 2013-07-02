#import "GHUser.h"
#import "GHUsers.h"

#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"


@implementation GHUser

- (void)setValues:(id)dict {
	self.name = [dict safeStringForKey:@"name"];
	self.email = [dict safeStringForKey:@"email"];
	self.userId = [dict safeStringForKey:@"id"];
	self.dob = [dict safeStringForKey:@"dob"];
	self.gender = [dict safeStringForKey:@"gender"];
	self.avatar = [dict safeDictForKey:@"avatar"];
	self.city_id = [dict safeStringForKey:@"avatar_url"];
	self.district_id = [dict safeStringForKey:@"district_id"];
	self.address = [dict safeStringForKey:@"address"];
	self.addressFull = [dict safeStringForKey:@"public_repos"];
	self.created = [dict safeDateForKey:@"created"];
}


@end