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

- (void)setLogin:(NSString *)login {
	_login = login;
	self.resourcePath = [NSString stringWithFormat:kUserFormat, self.login];
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

#pragma mark Associations

- (GHUsers *)following {
	if (!_following) {
		NSString *followingPath = [NSString stringWithFormat:kUserFollowingFormat, self.login];
		_following = [[GHUsers alloc] initWithPath:followingPath];
	}
	return _following;
}

- (GHUsers *)followers {
	if (!_followers) {
		NSString *followersPath = [NSString stringWithFormat:kUserFollowersFormat, self.login];
		_followers = [[GHUsers alloc] initWithPath:followersPath];
	}
	return _followers;
}


#pragma mark User Following
- (void)checkUserFollowing:(GHUser *)user success:(resourceSuccess)success failure:(resourceFailure)failure {
	NSString *path = [NSString stringWithFormat:kUserFollowFormat, user.login];
	GHResource *resource = [[GHResource alloc] initWithPath:path];
	[resource loadWithParams:nil start:nil success:^(GHResource *instance, id data) {
		if (success) success(self, data);
	} failure:^(GHResource *instance, NSError *error) {
		if (failure) failure(self, error);
	}];
}

- (void)setFollowing:(BOOL)follow forUser:(GHUser *)user success:(resourceSuccess)success failure:(resourceFailure)failure {
	NSString *path = [NSString stringWithFormat:kUserFollowFormat, user.login];
	NSString *method = follow ? kRequestMethodPut : kRequestMethodDelete;
	GHResource *resource = [[GHResource alloc] initWithPath:path];
	[resource saveWithParams:nil path:path method:method start:nil success:^(GHResource *instance, id data) {
		if (follow) {
			[self.following addObject:user];
		} else {
			[self.following removeObject:user];
		}
		[self.following markAsChanged];
		if (success) success(self, data);
	} failure:^(GHResource *instance, NSError *error) {
		if (failure) failure(self, error);
	}];
}
@end