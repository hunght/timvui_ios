#import "GHResource.h"

@class GHUsers, TVComments;

@interface GHUser : GHResource
@property(nonatomic,strong)NSString *last_name;
@property(nonatomic, strong)NSString*first_name;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *dob;
@property(nonatomic,strong)NSString *city_id;
@property(nonatomic,strong)NSString *gender;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)UIImage *gravatar;

@property(nonatomic,strong)GHUsers *following;
@property(nonatomic,strong)GHUsers *followers;

@property(nonatomic,strong)NSString *district_id;
@property(nonatomic,strong)NSString  *address;
@property(nonatomic,strong)NSString *addressFull;
@property(nonatomic,strong)NSDate *created;

@end