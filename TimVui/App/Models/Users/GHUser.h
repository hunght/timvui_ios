#import "GHResource.h"
#import "IOCAppConstants.h"

@class GHUsers, GHOrganizations;

@interface GHUser : GHResource
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *login;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *dob;
@property(nonatomic,strong)NSString *city_id;
@property(nonatomic,strong)NSString *gender;
@property(nonatomic,strong)NSDictionary *avatar;
@property(nonatomic,strong)UIImage *gravatar;

@property(nonatomic,strong)GHUsers *following;
@property(nonatomic,strong)GHUsers *followers;

@property(nonatomic,strong)NSString *district_id;
@property(nonatomic,strong)NSString  *address;
@property(nonatomic,strong)NSString *addressFull;
@property(nonatomic,strong)NSDate *created;

- (id)initWithLogin:(NSString *)login;

@end