#import "GHResource.h"


@class GHUsers, GHOrganizations;

@interface GHUser : GHResource
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *login;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *company;
@property(nonatomic,strong)NSString *location;
@property(nonatomic,strong)NSURL *gravatarURL;
@property(nonatomic,strong)NSURL *blogURL;
@property(nonatomic,strong)NSURL *htmlURL;
@property(nonatomic,strong)UIImage *gravatar;

@property(nonatomic,strong)GHUsers *following;
@property(nonatomic,strong)GHUsers *followers;

@property(nonatomic,assign)NSUInteger publicGistCount;
@property(nonatomic,assign)NSUInteger privateGistCount;
@property(nonatomic,assign)NSUInteger publicRepoCount;
@property(nonatomic,assign)NSUInteger privateRepoCount;
@property(nonatomic,assign)NSUInteger followersCount;
@property(nonatomic,assign)NSUInteger followingCount;

- (id)initWithLogin:(NSString *)login;
- (void)setFollowing:(BOOL)follow forUser:(GHUser *)user success:(resourceSuccess)success failure:(resourceFailure)failure;
@end