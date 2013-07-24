#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GHResource.h"
#import "TVCuisines.h"
@class GHUser, TVComment,TVCoupons;

@interface TVBranch : NSObject
@property(nonatomic,strong)NSString *branchID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *price_avg;
@property(nonatomic,strong)NSDictionary *arrURLImages;
@property(nonatomic,assign)int coupon_count;
@property(nonatomic,strong)TVCoupons *coupons;
@property(nonatomic,strong)TVCuisines *menu;
@property(nonatomic,strong)NSArray *special_content;
@property(nonatomic,strong)NSString *address_full;
@property(nonatomic,assign)CLLocationCoordinate2D latlng;

@property(nonatomic,assign)int image_count;
@property(nonatomic,strong)NSArray *images;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSDictionary *cats;
@property(nonatomic,strong)NSDictionary *district;
@property(nonatomic,strong)NSString *space;
@property(nonatomic,strong)NSString *time_open;
@property(nonatomic,strong)NSString *time_close;

@property(nonatomic,strong)NSString *waiting_start;
@property(nonatomic,strong)NSString *waiting_end;

@property(nonatomic,strong)NSString *holiday;
@property(nonatomic,strong)NSString *year;

@property(nonatomic,strong)NSDictionary *styleFoody;
@property(nonatomic,strong)NSDictionary *services;
@property(nonatomic,strong)NSDictionary *purpose;
@property(nonatomic,strong)NSDictionary *adaptive;
@property(nonatomic,strong)NSDictionary *decoration;
@property(nonatomic,strong)NSDictionary *cuisine;


@property(nonatomic,strong)NSDictionary *public_locations;
@property(nonatomic,strong)NSString *direction;
@property(nonatomic,readonly)BOOL isCommentEvent;
@property(nonatomic,readonly)BOOL read;

- (id)initWithDict:(NSDictionary *)dict;
- (void)setValues:(id)dict;
- (void)markAsRead;

@end