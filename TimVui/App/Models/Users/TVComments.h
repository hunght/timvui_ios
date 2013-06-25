#import <Foundation/Foundation.h>
#import "GHCollection.h"


@class GHUser;

@interface TVComments : GHCollection
@property(nonatomic,strong)GHUser *user;
@property(nonatomic,strong)NSString *last_id;
@end