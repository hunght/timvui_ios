#import <Foundation/Foundation.h>


@class GHUser;

@interface TVCuisine : NSObject
@property(nonatomic,strong)NSString *cuisineID;
@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString* price_old;
@property(nonatomic,assign)int like_count;
- (id)initWithDict:(NSDictionary *)dict;
- (void)setValues:(id)dict;
- (void)markAsRead;
@end