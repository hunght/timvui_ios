#import "GHUser.h"
#import "GHUsers.h"

#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"


@implementation GHUser

- (void)setValues:(id)dict {
	self.last_name = [dict safeStringForKey:@"last_name"];
    self.first_name = [dict safeStringForKey:@"first_name"];
    
	self.email = [dict safeStringForKey:@"email"];
	self.userId = [dict safeStringForKey:@"id"];
	self.dob = [dict safeStringForKey:@"dob"];
	self.gender = [dict safeStringForKey:@"gender"];
	self.avatar = [dict safeStringForKey:@"avatar"];
	self.city_id = [dict safeStringForKey:@"city_id"];
    self.address = [dict safeStringForKey:@"address"];
    
	self.district_id = [dict safeStringForKey:@"district_id"];
	self.addressFull = [dict safeStringForKey:@"public_repos"];
	self.created = [dict safeDateForKey:@"created"];
}


@end