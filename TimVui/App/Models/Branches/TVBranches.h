#import <Foundation/Foundation.h>
#import "GHCollection.h"



@interface TVBranches : GHCollection
@property(nonatomic,strong)NSDate *lastUpdate;

- (id)initWithPath:(NSString *)path account:(GHAccount *)account;
@end