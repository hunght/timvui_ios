#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GHResource.h"
#import "TVCuisines.h"

@interface TVKaraoke : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *type;

@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSArray *price;

@property(nonatomic,strong)NSString *count;
@property(nonatomic,strong)NSArray *images;


- (id)initWithDict:(NSDictionary *)dict;
- (void)setValues:(id)dict;

@end