#import <Foundation/Foundation.h>
#import "GHCollection.h"


@interface TVGroupCuisines : NSObject
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,strong)NSString *groupID;
@property(nonatomic,strong)NSString *name;
- (id)initWithDict:(NSArray *)dict;
@end