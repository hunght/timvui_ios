#import "GHUser.h"
#import "GHUsers.h"
#import "GHOrganizations.h"

#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"


@implementation GHUser

- (id)initWithLogin:(NSString *)login {
	self = [self init];
	if (self) {
		self.login = login;
	}
	return self;
}

- (NSUInteger)hash {
	return [[self.login lowercaseString] hash];
}

- (int)compareByName:(GHUser *)otherUser {
	return [self.login localizedCaseInsensitiveCompare:otherUser.login];
}



- (void)setValues:(id)dict {
	NSString *login = [dict safeStringForKey:@"login"];
	if (!login.isEmpty && ![self.login isEqualToString:login]) {
		self.login = login;
	}
	// TODO: Remove email check once the API change is done.
	id email = [dict valueForKeyPath:@"email" defaultsTo:nil];
	if ([email isKindOfClass:NSDictionary.class]) {
		NSString *state = [email safeStringForKey:@"state"];
		email = [state isEqualToString:@"verified"] ? [dict safeStringForKey:@"email"] : nil;
	}
	self.name = [dict safeStringForKey:@"name"];
	self.email = email;
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