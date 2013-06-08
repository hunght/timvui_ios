#import "GHOrganization.h"
#import "GHUser.h"
#import "GHUsers.h"
#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"


@implementation GHOrganization

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

- (int)compareByName:(GHOrganization *)otherOrg {
	return [self.login localizedCaseInsensitiveCompare:otherOrg.login];
}

- (void)setLogin:(NSString *)login {
	_login = login;

	self.resourcePath = @"";
}

- (void)setGravatarURL:(NSURL *)url {
	_gravatarURL = url;
	if (self.gravatarURL && !self.gravatar) {

	}
}

- (void)setValues:(id)dict {
	NSDictionary *resource = [dict safeDictForKey:@"organization"] ? [dict safeDictForKey:@"organization"] : dict;
	NSString *login = [resource safeStringForKey:@"login"];
	// TODO: Remove email check once the API change is done.
	id email = [dict valueForKeyPath:@"email" defaultsTo:nil];
	if ([email isKindOfClass:NSDictionary.class]) {
		NSString *state = [email safeStringForKey:@"state"];
		email = [state isEqualToString:@"verified"] ? [dict safeStringForKey:@"email"] : nil;
	}
	// Check the values before setting them, because the organizations list does
	// not include all fields. This unsets some fields when reloading the orgs,
	// after an org has already been fully loaded (because the orgs are cached).
	NSString *name = [resource safeStringOrNilForKey:@"name"];
	NSString *location = [resource safeStringOrNilForKey:@"location"];
	NSURL *blogURL = [resource safeURLForKey:@"blog"];
	NSURL *htmlURL = [resource safeURLForKey:@"html_url"];
	NSURL *gravatarURL = [resource safeURLForKey:@"avatar_url"];
	NSInteger publicRepoCount = [resource safeIntegerForKey:@"public_repos"];
	NSInteger privateRepoCount = [resource safeIntegerForKey:@"total_private_repos"];
	if (!login.isEmpty && ![self.login isEqualToString:login]) self.login = login;
	if (name) self.name = name;
	if (email) self.email = email;
	if (blogURL) self.location = location;
	if (location) self.blogURL = blogURL;
	if (htmlURL) self.htmlURL = htmlURL;
	if (gravatarURL) self.gravatarURL = gravatarURL;
	if (publicRepoCount) self.publicRepoCount = publicRepoCount;
	if (privateRepoCount) self.privateRepoCount = privateRepoCount;
}

#pragma mark Associations



- (GHUsers *)publicMembers {
	if (!_publicMembers) {
		NSString *membersPath = @"";
		_publicMembers = [[GHUsers alloc] initWithPath:membersPath];
	}
	return _publicMembers;
}


@end