#import <Foundation/Foundation.h>


@class GHUser, GHOrganization,TVCoupons;

@interface TVBranch : NSObject
@property(nonatomic,strong)NSString *branchID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *price_avg;
@property(nonatomic,strong)NSDictionary *arrURLImages;
@property(nonatomic,assign)int coupon_count;
@property(nonatomic,strong)TVCoupons *coupons;
@property(nonatomic,strong)NSString *special_content;
@property(nonatomic,strong)NSString *address_full;
@property(nonatomic,strong)NSString *latlng;


@property(nonatomic,readonly)BOOL isCommentEvent;
@property(nonatomic,readonly)BOOL read;

- (id)initWithDict:(NSDictionary *)dict;
- (void)setValues:(id)dict;
- (void)markAsRead;
@end