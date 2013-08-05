#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GHResource.h"
#import "TVCuisines.h"
@class GHUser, TVComment,TVCoupons;

@interface TVEvent : NSObject
@property(nonatomic,strong)NSString *eventID;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *alias;
@property(nonatomic,strong)NSString *desc;

@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSArray *addresses;

@property(nonatomic,strong)NSString *hot;
@property(nonatomic,strong)NSDate *start;
@property(nonatomic,strong)NSDate *end;
@property(nonatomic,strong)NSString *image;

@property(nonatomic,strong)NSDate *created;


- (id)initWithDict:(NSDictionary *)dict;
- (void)setValues:(id)dict;

@end