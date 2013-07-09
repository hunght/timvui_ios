#import <Foundation/Foundation.h>
#import "GHCollection.h"


@interface TVCuisines : NSObject
@property(nonatomic,strong)NSMutableArray *items;
@property(assign,nonatomic)int count;
- (void)setValues:(id)values;
@end