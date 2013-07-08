#import <Foundation/Foundation.h>


@class GHUser;

@interface TVCuisine : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString* price_old;

- (id)initWithDict:(NSDictionary *)dict;
- (void)setValues:(id)dict;
- (void)markAsRead;
@end