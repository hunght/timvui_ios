#import <Foundation/Foundation.h>
#import "GHCollection.h"


@interface TVCoupons : GHCollection
@property(nonatomic,strong)NSDate *lastUpdate;

- (id)initWithPath:(NSString *)path;
@end