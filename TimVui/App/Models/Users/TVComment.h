#import "GHResource.h"


@class GHUsers;

@interface TVComment : GHResource
@property(nonatomic,strong)NSString *commentID;
@property(nonatomic,strong)NSString *user_name;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSDate *created;
@property(nonatomic,strong)NSDictionary *arrURLImages;
@property(nonatomic,assign)int like_count;
@property(nonatomic,assign)int rating;
@property(nonatomic,strong)NSString *user_id;

- (id)initWithDict:(NSDictionary *)dict;
@end