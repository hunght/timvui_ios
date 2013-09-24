#import <Foundation/Foundation.h>
#import "GHCollection.h"



@interface TVBranches : GHCollection
@property(nonatomic,strong)NSDate *lastUpdate;
@property(nonatomic, assign)int countAddedItems;
@property(nonatomic,assign)BOOL isNotSearchAPIYES;
@end